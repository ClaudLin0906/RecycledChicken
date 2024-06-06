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
    
    @IBOutlet weak var specialTaskBackgroundView:UIView!
        
    private var observation: NSKeyValueObservation?
    
    private var locationManager = CLLocationManager()
    
//    private var fakeMapInfosData:[MapInfo] = 
//    [
//        MapInfo(isVisible: true, storeName: "店家1", storeID: "店家1ID", cellPath: "店家1cellPath", remainingProcessable: RemainingProcessableInfo(bottle: 12, battery: 10), status: "可投遞", storeAddress: "店家1storeAddress", coordinate: "24.8355593, 121.0090052"),
//        MapInfo(isVisible: true, storeName: "店家2", storeID: "店家2ID", cellPath: "店家2cellPath", remainingProcessable: RemainingProcessableInfo(bottle: 12, battery: 10), status: "滿", storeAddress: "店家2storeAddress", coordinate: "22.8355593, 121.0090052"),
//        MapInfo(isVisible: true, storeName: "店家3", storeID: "店家3ID", cellPath: "店家3cellPath", remainingProcessable: RemainingProcessableInfo(bottle: 0, battery: 10), status: "可投遞", storeAddress: "店家3storeAddress", coordinate: "20.8355593, 121.0090052"),
//        MapInfo(isVisible: true, storeName: "店家4", storeID: "店家4ID", cellPath: "店家4cellPath", remainingProcessable: RemainingProcessableInfo(bottle: 12, battery: 0), status: "可投遞", storeAddress: "店家4storeAddress", coordinate: "18.8355593, 121.0090052"),
//        MapInfo(isVisible: true, storeName: "店家5", storeID: "店家5ID", cellPath: "店家5cellPath", remainingProcessable: RemainingProcessableInfo(bottle: 12, battery: 10), status: "可投遞", storeAddress: "店家5storeAddress", coordinate: "16.8355593, 121.0090052")
//    ]
    
    private var mapInfosData:[MapInfo] = []
    
    private var currentMapInfos:[MapInfo] = []
    
    private var specialTaskMapInfos:[MapInfo] = []
        
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
                showAlert(VC: self, title: "error".localized, message: errorMSG)
                return
            }
            
            if let data = data, let mapInfos = try? JSONDecoder().decode([MapInfo].self, from: data) {
                mapInfosData.removeAll()
                specialTaskMapInfos.removeAll()
                currentMapInfos.removeAll()
                mapInfos.forEach({ mapInfo in
                    var newMapInfo = mapInfo
                    if newMapInfo.machineStatus == nil, let machineRemaining = newMapInfo.machineRemaining {
                        if machineRemaining.battery ?? 0 > 0 || machineRemaining.bottle ?? 0 > 0 || machineRemaining.can ?? 0 > 0 || machineRemaining.cup ?? 0 > 0 || machineRemaining.colorBottle ?? 0 > 0 {
                            newMapInfo.machineStatus = .submit
                        }
                    }
                    mapInfosData.append(newMapInfo)
                })
//                mapInfosData = fakeMapInfosData
                mapInfosData.forEach({
                    if $0.taskDescription != nil {
                        specialTaskMapInfos.append($0)
                    }
                })
                currentMapInfos = mapInfosData
                addMarker(currentMapInfos)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
    }
    
    private func showSpecialTask() {
        guard specialTaskMapInfos.count > 0 else {
            specialTaskBackgroundView.isHidden = true
            return
        }
        specialTaskBackgroundView.isHidden = false
        specialTaskMapInfos.forEach { mapInfo in
            let specialTaskView = SpecialTaskView()
            specialTaskView.info = mapInfo
            specialTaskBackgroundView.addSubview(specialTaskView)
        }
    }
    
    private func addMarker(_ infos:[MapInfo]) {
        DispatchQueue.main.async { [self] in
            mapView?.clear()
            infos.forEach { info in
                guard let latitudeString = info.machineLocation?.latitude, let latitude = Double(latitudeString), let longitudeString = info.machineLocation?.longitude, let longitude = Double(longitudeString) else { return }
                let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                let maker = GMSMarker()
                maker.position = coordinate
                maker.map = mapView
                maker.icon = imageWithImage(image: UIImage(named: "组 265")!, scaledToSize: CGSize(width: 50, height: 50))
                maker.icon = getMakerIcon(info)
                maker.title = info.name
            }
//            for mapInfo in infos {
//                let maker = GMSMarker()
//                if let coordinateArr = try? mapInfo.coordinate.components(separatedBy: ", "), coordinateArr.count == 2 {
//                    if let latitude = Double(coordinateArr[0]), let longitude = Double(coordinateArr[1]) {
//                        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//                        maker.position = coordinate
//                        maker.map = mapView
//                        maker.icon = imageWithImage(image: UIImage(named: "组 265")!, scaledToSize: CGSize(width: 50, height: 50))
//                        maker.icon = getMakerIcon(mapInfo)
//                        maker.title = mapInfo.storeName
//                    }
//                }
//            }
        }
    }
    
    private func getMakerIcon(_ info:MapInfo) -> UIImage? {
        var image:UIImage?
        switch info.machineStatus {
        case .submit:
            // remainBottle remainBattery remainCan remainCup isSpecial
            let imageMap: [String: UIImage] = [
                "false,false,false,true,false": #imageLiteral(resourceName: "ch-34"),
                "false,false,false,true,true": #imageLiteral(resourceName: "ch-48"),
                "false,false,true,false,false": #imageLiteral(resourceName: "ch-33"),
                "false,false,true,false,true": #imageLiteral(resourceName: "ch-47"),
                "false,false,true,true,false": #imageLiteral(resourceName: "ch-29"),
                "false,false,true,true,true": #imageLiteral(resourceName: "ch-43"),
                "false,true,false,false,false": #imageLiteral(resourceName: "ch-31"),
                "false,true,false,false,true": #imageLiteral(resourceName: "ch-45"),
                "false,true,false,true,false": #imageLiteral(resourceName: "ch-27"),
                "false,true,false,true,true": #imageLiteral(resourceName: "ch-41"),
                "false,true,true,false,false": #imageLiteral(resourceName: "ch-26"),
                "false,true,true,false,true": #imageLiteral(resourceName: "ch-40"),
                "false,true,true,true,false": #imageLiteral(resourceName: "ch-24"),
                "false,true,true,true,true": #imageLiteral(resourceName: "ch-38"),
                "true,false,false,false,false": #imageLiteral(resourceName: "ch-32"),
                "true,false,false,false,true": #imageLiteral(resourceName: "ch-48"),
                "true,false,false,true,false": #imageLiteral(resourceName: "ch-28"),
                "true,false,false,true,true": #imageLiteral(resourceName: "ch-42"),
                "true,false,true,false,false": #imageLiteral(resourceName: "ch-30"),
                "true,false,true,false,true": #imageLiteral(resourceName: "ch-44"),
    //            "true,false,true,true,false": "image23",
    //            "true,false,true,true,true": "image24",
                "true,true,false,false,false": #imageLiteral(resourceName: "ch-25"),
                "true,true,false,false,true": #imageLiteral(resourceName: "ch-39"),
                "true,true,false,true,false": #imageLiteral(resourceName: "ch-23"),
                "true,true,false,true,true": #imageLiteral(resourceName: "ch-37"),
                "true,true,true,false,false": #imageLiteral(resourceName: "ch-22"),
                "true,true,true,false,true": #imageLiteral(resourceName: "ch-36"),
    //            "true,true,true,true,false": "image31",
    //            "true,true,true,true,true": "image32"
            ]

            if let machineRemaining = info.machineRemaining {
                var remainBottle = false
                var remainBattery = false
                var remainCan = false
                var remainCup = false
                var isSpecial = false
                if machineRemaining.bottle ?? 0 > 0 || machineRemaining.colorBottle ?? 0 > 0 {
                    remainBottle = true
                }
                if machineRemaining.battery ?? 0 > 0 {
                    remainBattery = true
                }
                if machineRemaining.can ?? 0 > 0 {
                    remainCan = true
                }
                if machineRemaining.cup ?? 0 > 0 {
                    remainCup = true
                }
                if info.taskDescription != nil {
                    isSpecial = true
                }
                let key = "\(remainBottle),\(remainBattery),\(remainCan),\(remainCup),\(isSpecial)"
                
                if let imageChicken = imageMap[key] {
                    image = imageChicken
                }
            }
        default:
            if info.taskDescription != nil {
                image = #imageLiteral(resourceName: "ch-51")
            }
            if info.taskDescription == nil {
                image = #imageLiteral(resourceName: "ch-50")
            }
        }
        return imageWithImage(image:image, scaledToSize: CGSize(width: 50, height: 50))
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
                currentMapInfos = mapInfosData.filter({ mapInfo in
                    if let name = mapInfo.name {
                        return text.contains(text)
                    }
                    if let address = mapInfo.address {
                        return text.contains(address)
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
        let mapInfoArr = currentMapInfos.filter { mapInfo in
            if let title = marker.title {
                if title == mapInfo.name {
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
