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

    @IBOutlet var mapView:GMSMapView!
    
    @IBOutlet var iconView1:IconView!
    
    @IBOutlet var iconView2:IconView!
    
    @IBOutlet var iconView3:IconView!
        
    private var observation: NSKeyValueObservation?
    
    private var locationManager = CLLocationManager()
    
    private var location: CLLocation? {
      didSet {
        guard oldValue == nil, let firstLocation = location else { return }
        mapView.camera = GMSCameraPosition(target: firstLocation.coordinate, zoom: 14)
      }
    }
    
    private var mapInfos:[MapInfo] = []
    
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
        NetworkManager.shared.getJSONBody(urlString: APIUrl.domainName+APIUrl.machineStatus, authorizationToken: CommonKey.shared.authToken) { (data, statusCode, errorMSG) in
            guard statusCode == 200 else {
                showAlert(VC: self, title: "發生錯誤", message: errorMSG, alertAction: nil)
                return
            }
            
            if let data = data, let mapInfos = try? JSONDecoder().decode([MapInfo].self, from: data) {
                self.mapInfos = mapInfos
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
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
//        if CLLocationManager.locationServicesEnabled() {
//            switch(CLLocationManager.authorizationStatus()) {
//            case .notDetermined, .restricted, .denied:
//                return false
//            case .authorizedAlways, .authorizedWhenInUse:
//                return true
//            @unknown default:
//                return false
//            }
//        }
//        return false
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
        
        iconView1.icon.backgroundColor = CommonColor.shared.color5
        iconView1.title.text = "0~40%"
        
        iconView2.icon.backgroundColor = CommonColor.shared.color3
        iconView2.title.text = "50%"
        
        iconView3.icon.backgroundColor = #colorLiteral(red: 0.9574549794, green: 0.5093209743, blue: 0.3308191895, alpha: 1)
        iconView3.title.text = "滿位"
        
    }
    
    @IBAction func goToStoreList(_ sender:UIButton) {
        if let navigationController = self.navigationController, let VC = UIStoryboard(name: "StoreList", bundle: Bundle.main).instantiateViewController(identifier: "StoreList") as? StoreListVC {
            pushVC(targetVC: VC, navigation: navigationController)
        }
    }
    
}


extension StoreMapVC: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        true
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
        guard mapInfos.count > 0 else { return }
        self.mapView?.clear()
        let location = locations.last
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 17.0)
        self.mapView?.animate(to: camera)
        for mapInfo in mapInfos {
            let maker = GMSMarker()
            let coordinateArr = try? mapInfo.coordinate.components(separatedBy: ", ")
            if let coordinateArr = coordinateArr, coordinateArr.count == 2{
                if let latitude = Double(coordinateArr[0]), let longitude = Double(coordinateArr[1]) {
                    let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    maker.position = coordinate
                }
            }
        }
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2DMake( (location?.coordinate.latitude)! + 0.001, (location?.coordinate.longitude)! )
//        marker.map = mapView
//        marker.icon = imageWithImage(image: UIImage(named: "组 227")!, scaledToSize: CGSize(width: 50, height: 50))
//        marker.title = "標題"
//        marker.snippet = "副標題"
//
//        let marker1 = GMSMarker()
//        marker1.position = CLLocationCoordinate2DMake( (location?.coordinate.latitude)!, (location?.coordinate.longitude)! + 0.001)
//        marker1.map = mapView
//        marker1.icon = imageWithImage(image: UIImage(named: "组 265")!, scaledToSize: CGSize(width: 50, height: 50))
//        marker1.title = "標題2"
//        marker1.snippet = "副標題2"
//
//        let marker2 = GMSMarker()
//        marker2.position = CLLocationCoordinate2DMake( (location?.coordinate.latitude)! + 0.001, (location?.coordinate.longitude)! + 0.001)
//        marker2.map = mapView
//        marker2.icon = imageWithImage(image: UIImage(named: "组 265")!, scaledToSize: CGSize(width: 50, height: 50))
//        marker2.title = "標題3"
//        marker2.snippet = "副標題3"
        
//        self.locationManager.stopUpdatingLocation()

    }

}
