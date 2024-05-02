//
//  StationListVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2024/3/3.
//

import UIKit
import DropDown
import SkeletonView
import GooglePlaces

class StationListVC: CustomVC {
    
    @IBOutlet weak var dropDownView:DropDownView!
    
    @IBOutlet weak var keyWordTextfiekd:UITextField!
    
    @IBOutlet weak var tableView:UITableView!
        
    private var mapInfos:[MapInfo] = []
    
    private var filterMapInfos:[MapInfo] = []
    
    private var fakeMapInfosData:[MapInfo] =
    [
        MapInfo(isVisible: true, storeName: "店家1", storeID: "店家1ID", cellPath: "店家1cellPath", remainingProcessable: RemainingProcessableInfo(bottle: 12, battery: 10), status: "可投遞", storeAddress: "店家1storeAddress", coordinate: "24.8355593, 121.0090052"),
        MapInfo(isVisible: true, storeName: "店家2", storeID: "店家2ID", cellPath: "店家2cellPath", remainingProcessable: RemainingProcessableInfo(bottle: 12, battery: 10), status: "滿", storeAddress: "店家2storeAddress", coordinate: "22.8355593, 121.0090052"),
        MapInfo(isVisible: true, storeName: "店家3", storeID: "店家3ID", cellPath: "店家3cellPath", remainingProcessable: RemainingProcessableInfo(bottle: 0, battery: 10), status: "可投遞", storeAddress: "店家3storeAddress", coordinate: "20.8355593, 121.0090052"),
        MapInfo(isVisible: true, storeName: "店家4", storeID: "店家4ID", cellPath: "店家4cellPath", remainingProcessable: RemainingProcessableInfo(bottle: 12, battery: 0), status: "可投遞", storeAddress: "店家4storeAddress", coordinate: "18.8355593, 121.0090052"),
        MapInfo(isVisible: true, storeName: "店家5", storeID: "店家5ID", cellPath: "店家5cellPath", remainingProcessable: RemainingProcessableInfo(bottle: 12, battery: 10), status: "可投遞", storeAddress: "店家5storeAddress", coordinate: "16.8355593, 121.0090052")
    ]
    
    private var filtered = false
    
    private var locationManager = CLLocationManager()
    
    private var currentLocation: CLLocation?
    {
        willSet {
            if newValue != nil {
                sortDisance()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "stationList".localized
        UIInit()
        getStoreInfo()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit() {
        dropDownView.changeType(.darkColor)
        dropDownView.setDefaultTitle("region".localized)
        dropDownView.setFontSize(14)
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        imageView.image = UIImage(named: "组 182")
        imageView.center = leftView.center
        imageView.contentMode = .scaleAspectFit
        leftView.addSubview(imageView)
        keyWordTextfiekd.leftViewMode = .always
        keyWordTextfiekd.leftView = leftView
        keyWordTextfiekd.clearButtonMode = .always
        keyWordTextfiekd.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        tableView.showAnimatedSkeleton()
        locationManager.delegate = self
        mapInfos = fakeMapInfosData
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultNavigationBackBtn2()
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
    
    private func getLocation(_ locationStr:String) -> CLLocation? {
        if let coordinateArr = try? locationStr.components(separatedBy: ", "), coordinateArr.count == 2 {
            if let latitude = Double(coordinateArr[0]), let longitude = Double(coordinateArr[1]) {
                return CLLocation(latitude: latitude, longitude: longitude)
            }
        }
        return nil
    }
    
    private func sortDisance() {
        guard let currentLocation = currentLocation else { return }
        var newMapInfos:[MapInfo] = []
        newMapInfos = mapInfos.sorted { mapInfo1, mapInfo2 in
            guard let coordinate1 = getLocation(mapInfo1.coordinate), let coordinate2 = getLocation(mapInfo2.coordinate) else { return false }
            let distance1 = coordinate1.distance(from: currentLocation)
            let distance2 = coordinate2.distance(from: currentLocation)
            return distance1 > distance2
        }
        mapInfos.append(contentsOf: newMapInfos)
        print(" end \(mapInfos)")
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
    
    private func getStoreInfo(){
        NetworkManager.shared.getJSONBody(urlString: APIUrl.domainName+APIUrl.machineStatus, authorizationToken: CommonKey.shared.authToken) { (data, statusCode, errorMSG) in
            guard statusCode == 200 else {
                showAlert(VC: self, title: "error".localized, message: errorMSG)
                return
            }
            
            if let data = data, let mapInfos = try? JSONDecoder().decode([MapInfo].self, from: data) {
                self.mapInfos = mapInfos
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        self.tableView.stopSkeletonAnimation()
                        self.view.hideSkeleton()
                    })
                }
            }
        }
    }
    
    private func getTableViewCount() -> Int {
        if !filterMapInfos.isEmpty {
            return filterMapInfos.count
        }
        return  filtered ? 0 : mapInfos.count
    }
    
    private func filterText(_ query:String?) {
        guard let query = query else { return }
        filterMapInfos.removeAll()
        
        let newData = mapInfos.filter({
            let storeNameResult =  $0.storeName.range(of: query, options: .caseInsensitive)
            let storeAddressResult = $0.storeAddress.range(of: query, options: .caseInsensitive)
            if storeNameResult != nil || storeAddressResult != nil {
                return true
            }else{
                return false
            }
        })
        
        filterMapInfos.append(contentsOf: newData)
        
        if !filterMapInfos.isEmpty || keyWordTextfiekd.text != ""{
            filtered = true
        }else{
            filtered = false
        }

    }
    
    @objc private func textFieldDidChange(_ textfield:UITextField){
        if let text = textfield.text {
            filterText(text)
        }
    }
    
    @IBAction func goToStoreList(_ sender:UIButton) {
        if let navigationController = self.navigationController, let VC = UIStoryboard(name: "SiteList", bundle: Bundle.main).instantiateViewController(identifier: "SiteList") as? SiteListVC {
            pushVC(targetVC: VC, navigation: navigationController)
        }
    }

}


extension StationListVC: UITableViewDelegate {
    
}

extension StationListVC: SkeletonTableViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        StationListTableViewCell.identifier
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        getTableViewCount()
        3
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, skeletonCellForRowAt indexPath: IndexPath) -> UITableViewCell? {
        nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StationListTableViewCell.identifier, for: indexPath) as! StationListTableViewCell
        return cell
    }
    
}

extension StationListVC:CLLocationManagerDelegate {
    
    //Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            currentLocation = location
            locationManager.stopUpdatingLocation()
        }
    }

}
