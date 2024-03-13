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
        
    private var observation: NSKeyValueObservation?
    
    private var locationManager = CLLocationManager()
    
    private var location: CLLocation? {
      didSet {
        guard oldValue == nil, let firstLocation = location else { return }
        mapView.camera = GMSCameraPosition(target: firstLocation.coordinate, zoom: 14)
      }
    }
    
    private var fakeMapInfosData:[MapInfo] = 
    [
        MapInfo(isVisible: true, storeName: "店家1", storeID: "店家1ID", cellPath: "店家1cellPath", remainingProcessable: RemainingProcessableInfo(bottle: 12, battery: 10), status: "可投遞", storeAddress: "店家1storeAddress", coordinate: "24.8355593, 121.0090052"),
        MapInfo(isVisible: true, storeName: "店家2", storeID: "店家2ID", cellPath: "店家2cellPath", remainingProcessable: RemainingProcessableInfo(bottle: 12, battery: 10), status: "滿", storeAddress: "店家2storeAddress", coordinate: "22.8355593, 121.0090052"),
        MapInfo(isVisible: true, storeName: "店家3", storeID: "店家3ID", cellPath: "店家3cellPath", remainingProcessable: RemainingProcessableInfo(bottle: 0, battery: 10), status: "可投遞", storeAddress: "店家3storeAddress", coordinate: "20.8355593, 121.0090052"),
        MapInfo(isVisible: true, storeName: "店家4", storeID: "店家4ID", cellPath: "店家4cellPath", remainingProcessable: RemainingProcessableInfo(bottle: 12, battery: 0), status: "可投遞", storeAddress: "店家4storeAddress", coordinate: "18.8355593, 121.0090052"),
        MapInfo(isVisible: true, storeName: "店家5", storeID: "店家5ID", cellPath: "店家5cellPath", remainingProcessable: RemainingProcessableInfo(bottle: 12, battery: 10), status: "可投遞", storeAddress: "店家5storeAddress", coordinate: "16.8355593, 121.0090052")
    ]
    
    private var mapInfosData:[MapInfo] = []
    
    private var currentMapInfos:[MapInfo] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isLocationServicesEnabled() {
           locationManager.startUpdatingLocation()
        } else {
           locationManager.requestWhenInUseAuthorization()
        }
        NetworkManager.shared.getJSONBody(urlString: APIUrl.domainName+APIUrl.machineStatus, authorizationToken: CommonKey.shared.authToken) { [self] (data, statusCode, errorMSG) in
            guard statusCode == 200 else {
                showAlert(VC: self, title: "error".localized, message: errorMSG, alertAction: nil)
                return
            }
            
            if let data = data, let mapInfos = try? JSONDecoder().decode([MapInfo].self, from: data) {
//                self.mapInfosData = mapInfos
                mapInfosData = fakeMapInfosData
                currentMapInfos = mapInfosData
                addMarker(currentMapInfos)
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
    }
    
    private func addMarker(_ infos:[MapInfo]) {
        DispatchQueue.main.async { [self] in
            mapView?.clear()
            for mapInfo in infos {
                let maker = GMSMarker()
                if let coordinateArr = try? mapInfo.coordinate.components(separatedBy: ", "), coordinateArr.count == 2 {
                    if let latitude = Double(coordinateArr[0]), let longitude = Double(coordinateArr[1]) {
                        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                        maker.position = coordinate
                        maker.map = mapView
                        maker.icon = imageWithImage(image: UIImage(named: "组 265")!, scaledToSize: CGSize(width: 50, height: 50))
                        maker.icon = getMakerIcon(mapInfo)
                        maker.title = mapInfo.storeName
                    }
                }
            }
        }
    }
    
    private func getMakerIcon(_ info:MapInfo) -> UIImage {
        var image = UIImage(named: "")
        switch info.status {
        case "可投遞":
            let bottle = info.remainingProcessable.bottle ?? 0
            let battery = info.remainingProcessable.battery ?? 0
            
            if battery > 0 && bottle > 0 {
                image = UIImage(named: "Group 125")
            }
            
            if battery > 0 && bottle == 0 {
                image = UIImage(named: "Group 128")
            }
            
            if battery == 0 && bottle > 0 {
                image = UIImage(named: "Group 129")
            }
            
        case "滿":
            image = UIImage(named: "Group 160")
        default:
            break
        }
        return imageWithImage(image:image!, scaledToSize: CGSize(width: 50, height: 50))
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
        
//        iconView1.icon.backgroundColor = CommonColor.shared.color5
//        iconView1.title.text = "0~40%"
//        
//        iconView2.icon.backgroundColor = CommonColor.shared.color3
//        iconView2.title.text = "50%"
//        
//        iconView3.icon.backgroundColor = #colorLiteral(red: 0.9574549794, green: 0.5093209743, blue: 0.3308191895, alpha: 1)
//        iconView3.title.text = "滿位"
        
        
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
    }
    
    @IBAction func goToStoreList(_ sender:UIButton) {
        if let navigationController = self.navigationController, let VC = UIStoryboard(name: "StationList", bundle: Bundle.main).instantiateViewController(identifier: "StationList") as? StationListVC {
            pushVC(targetVC: VC, navigation: navigationController)
        }
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            if text.trimmingCharacters(in: .whitespaces) != "" {
                currentMapInfos.removeAll()
                currentMapInfos = mapInfosData.filter({$0.storeName.contains(text) || $0.storeAddress.contains(text)})
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
        let mapInfoArr = currentMapInfos.filter { mapInfo in
            if let title = marker.title {
                if title == mapInfo.storeName {
                    return true
                }
            }
            return false
        }
        if !mapInfoArr.isEmpty {
            let mapInfo = mapInfoArr[0]
            amountView.setAmount(mapInfo)
            if amountView.stackView.subviews.count > 3 {
                amountViewHeight.constant = CGFloat(amountView.stackView.subviews.count * 30)
            }
        }
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("Current location: <\(coordinate.latitude), \(coordinate.longitude)>")
    }
    
    func mapView(_ mapView: GMSMapView, didTapMyLocation location: CLLocationCoordinate2D) {
        print("Current location: <\(location.latitude), \(location.longitude)>")
    }

}

extension StoreMapVC:CLLocationManagerDelegate {
    
    //Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 17.0)
        self.mapView?.animate(to: camera)
        locationManager.stopUpdatingLocation()
    }

}
