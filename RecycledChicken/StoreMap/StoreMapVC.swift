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
    
    @IBOutlet weak var iconView1:IconView!
    
    @IBOutlet weak var iconView2:IconView!
    
    @IBOutlet weak var iconView3:IconView!
    
    @IBOutlet weak var amountView:AmountView!
    
    @IBOutlet weak var searchTextField:UITextField!
        
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
                self.addMarker(mapInfos)
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
                        maker.title = mapInfo.storeName
                    }
                }
            }
        }
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
        
        iconView1.icon.backgroundColor = CommonColor.shared.color5
        iconView1.title.text = "0~40%"
        
        iconView2.icon.backgroundColor = CommonColor.shared.color3
        iconView2.title.text = "50%"
        
        iconView3.icon.backgroundColor = #colorLiteral(red: 0.9574549794, green: 0.5093209743, blue: 0.3308191895, alpha: 1)
        iconView3.title.text = "滿位"
        
        
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
        if let navigationController = self.navigationController, let VC = UIStoryboard(name: "StoreList", bundle: Bundle.main).instantiateViewController(identifier: "StoreList") as? StoreListVC {
            pushVC(targetVC: VC, navigation: navigationController)
        }
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            if text.trimmingCharacters(in: .whitespaces) != "" {
                let containMapInfos = mapInfos.filter({$0.storeName.contains(text) || $0.storeAddress.contains(text)})
                addMarker(containMapInfos)
            }else{
                addMarker(mapInfos)
            }
        }
    }
    
}


extension StoreMapVC: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let mapInfoArr = mapInfos.filter { mapInfo in
            if let title = marker.title {
                if title == mapInfo.storeName {
                    return true
                }
            }
            return false
        }
        if !mapInfoArr.isEmpty {
            let mapInfo = mapInfoArr[0]
            amountView.mapInfo = mapInfo
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
