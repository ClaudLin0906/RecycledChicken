//
//  StoreMapVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/11.
//

import UIKit
import GoogleMaps
import GooglePlaces

class StoreMapVC: CustomRootVC {

    @IBOutlet weak var mapView:GMSMapView!
    
    @IBOutlet weak var amountView:AmountView!
    
    @IBOutlet weak var searchTextField:UITextField!
    
    @IBOutlet weak var amountViewHeight:NSLayoutConstraint!
    
    @IBOutlet weak var specialTaskView:SpecialTaskView!
        
    private var observation: NSKeyValueObservation?
    
    private var locationManager = CLLocationManager()
    
    private var mapInfosData:[MapInfo] = []
    
    private var currentMapInfos:[MapInfo] = []
            
    override func viewDidLoad() {
        super.viewDidLoad()
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        CommonKey.shared.authToken = ""  // 測試用：模擬 token 失效
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isLocationServicesEnabled() {
           locationManager.startUpdatingLocation()
        } else {
           locationManager.requestWhenInUseAuthorization()
        }
        NetworkManager.shared.get(url: APIUrl.domainName + APIUrl.machineStatus,
                                   authorizationToken: CommonKey.shared.authToken,
                                   responseType: [MapInfo].self) { [weak self] result in
            switch result {
            case .success(let mapInfos):
                self?.mapInfosData.removeAll()
                self?.currentMapInfos.removeAll()
                mapInfos.forEach { mapInfo in
                    var newMapInfo = mapInfo
                    if newMapInfo.machineStatus == nil, let machineRemaining = newMapInfo.machineRemaining {
                        if machineRemaining.battery ?? 0 > 0 || machineRemaining.bottle ?? 0 > 0 || machineRemaining.colorlessBottle ?? 0 > 0 || machineRemaining.coloredBottle ?? 0 > 0 || machineRemaining.can ?? 0 > 0 || machineRemaining.cup ?? 0 > 0 {
                            newMapInfo.machineStatus = .submit
                        }
                    }
                    self?.mapInfosData.append(newMapInfo)
                }
                self?.currentMapInfos = self?.mapInfosData ?? []
                DispatchQueue.main.async {
                    self?.addMarker(self?.currentMapInfos ?? [])
                }
            case .failure(let error):
                self?.handleNetworkError(error)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
    }
    
    private func addMarker(_ infos:[MapInfo]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            mapView?.clear()
            infos.forEach { info in
                guard let latitudeString = info.machineLocation?.latitude, let latitude = Double(latitudeString), let longitudeString = info.machineLocation?.longitude, let longitude = Double(longitudeString) else { return }
                let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                let maker = GMSMarker()
                maker.position = coordinate
                maker.map = self.mapView
                maker.icon = self.getMakerIcon(info)
                maker.title = info.name
            }
        }
    }
    
    private func getMakerIcon(_ info: MapInfo) -> UIImage? {
        let isSpecial = info.description != nil && info.description != ""
        let markerSize = CGSize(width: 50, height: 60)

        let baseName = info.machineStatus == .submit
            ? (isSpecial ? "ic_special_mark" : "ic_normal_mark")
            : (isSpecial ? "ch-51" : "ch-50")

        guard let baseImage = UIImage(named: baseName) else { return nil }

        let availableItems: [RecycleItem]
        if info.machineStatus == .submit, let remaining = info.machineRemaining {
            availableItems = RecycleItem.allCases.filter { $0.remaining(from: remaining) != nil }
            print("[\(info.name ?? "")] remaining: \(remaining), availableItems: \(availableItems)")
        } else {
            availableItems = []
        }

        UIGraphicsBeginImageContextWithOptions(markerSize, false, 0)
        defer { UIGraphicsEndImageContext() }
        baseImage.draw(in: CGRect(origin: .zero, size: markerSize))
        if !availableItems.isEmpty {
            let iconWidth: CGFloat = 6
            let iconHeight: CGFloat = 10
            let spacing: CGFloat = 4
            let totalWidth = CGFloat(availableItems.count) * iconWidth + CGFloat(availableItems.count - 1) * spacing
            let startX = (markerSize.width - totalWidth) / 2
            let iconY = markerSize.height * 0.42
            availableItems.enumerated().forEach { i, item in
                let x = startX + CGFloat(i) * (iconWidth + spacing)
                UIImage(named: item.iconName)?.draw(in: CGRect(x: x, y: iconY, width: iconWidth, height: iconHeight))
            }
        }
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    private func isLocationServicesEnabled() -> Bool {
        let authorizationStatus: CLAuthorizationStatus
        if #available(iOS 14, *) {
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        switch authorizationStatus {
        case .notDetermined, .restricted, .denied:
            return false
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        @unknown default:
            return false
        }
    }
    
    private func UIInit(){
        mapView.mapType = .normal
        mapView.delegate = self
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = false
        mapView.isMyLocationEnabled = true
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.delegate = self
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.image = UIImage(named: "组 182")
        imageView.center = leftView.center
        imageView.contentMode = .scaleAspectFit
        leftView.addSubview(imageView)
        searchTextField.leftViewMode = .always
        searchTextField.leftView = leftView
        searchTextField.clearButtonMode = .always
        searchTextField.addTarget( self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        specialTaskView.delegate = self
    }
    
    @IBAction func goToStoreList(_ sender:UIButton) {
        if let navigationController = self.navigationController, let VC = UIStoryboard(name: "StationList", bundle: Bundle.main).instantiateViewController(identifier: "StationList") as? StationListVC {
            pushVC(targetVC: VC, navigation: navigationController)
        }
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            currentMapInfos.removeAll()
            if text.trimmingCharacters(in: .whitespaces) != "" {
                currentMapInfos = mapInfosData.filter({ mapInfo in
                    if let name = mapInfo.name {
                        return name.contains(text)
                    }
                    if let address = mapInfo.address {
                        return address.contains(text)
                    }
                    return false
                })
                addMarker(currentMapInfos)
            }else{
                currentMapInfos = mapInfosData
                addMarker(currentMapInfos)
            }
        }
    }
}

extension StoreMapVC: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let mapInfo = currentMapInfos.first { mapInfo in
            if let title = marker.title {
                if title == mapInfo.name, let machineStatus = mapInfo.machineStatus, machineStatus == .submit {
                    return true
                }
            }
            return false
        }
        
        if let mapInfo = mapInfo {
            amountView.setAmount(mapInfo)
            if amountView.stackView.subviews.count >= 3 {
                amountViewHeight.constant = CGFloat(amountView.stackView.subviews.count * 40)
            }
            if let taskDescription = mapInfo.description, taskDescription != "" {
                specialTaskView.info = mapInfo
                specialTaskView.setInfo()
                specialTaskView.isHidden = false
            } else {
                specialTaskView.isHidden = true
            }
        }
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
    }
    
    func mapView(_ mapView: GMSMapView, didTapMyLocation location: CLLocationCoordinate2D) {
    }

}

extension StoreMapVC:CLLocationManagerDelegate {
    
    //Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 17.0)
        self.mapView?.animate(to: camera)
        locationManager.stopUpdatingLocation()
    }

}

extension StoreMapVC:SpecialTaskViewDelegate {
    
    func tapClose() {
        amountView.isHidden = true
    }
    
}

