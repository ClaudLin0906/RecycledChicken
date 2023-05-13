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
        
    var observation: NSKeyValueObservation?
    
    var locationManager = CLLocationManager()
    
    var location: CLLocation? {
      didSet {
        guard oldValue == nil, let firstLocation = location else { return }
        mapView.camera = GMSCameraPosition(target: firstLocation.coordinate, zoom: 14)
      }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isLocationServicesEnabled() {
           locationManager.startUpdatingLocation()
        } else {
           locationManager.requestWhenInUseAuthorization()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
    }
    
    private func isLocationServicesEnabled() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                return false
            case .authorizedAlways, .authorizedWhenInUse:
                return true
            @unknown default:
                return false
            }
        }
        return false
    }
    
    private func UIInit(){
        mapView.mapType = .normal
        mapView.delegate = self
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
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
        let location = locations.last
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 17.0)
        self.mapView?.animate(to: camera)
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()

    }

}
