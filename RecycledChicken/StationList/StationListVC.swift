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
    
    private var areas:[String] = []
        
    private var locationManager = CLLocationManager()
    
    private let areasDropDown = DropDown()
    
    private var currentLocation: CLLocation?
    {
        willSet {
            if newValue != nil {
                addDropDownData()
                tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "stationList".localized
        UIInit()
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
        setupAreaDropDown()
    }
    
    private func sortDisanceAction() {
        sortDisance()
        filterMapInfos.append(contentsOf: mapInfos)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultNavigationBackBtn2()
        if isLocationServicesEnabled() {
           locationManager.startUpdatingLocation()
        } else {
           locationManager.requestWhenInUseAuthorization()
        }
        getStoreInfo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
    }
    
    private func setupAreaDropDown() {
        areasDropDown.anchorView = dropDownView
        areasDropDown.bottomOffset = CGPoint(x: 0, y: dropDownView.bounds.height)
        areasDropDown.selectionAction = { [weak self] (index, item) in
            guard let self = self else { return }
            dropDownView.setDefaultTitle(areas[index])
            filterMapInfos.removeAll()
            if index == 0 {
                filterMapInfos = mapInfos
            }
            if index != 0 {
                filterMapInfos = mapInfos.filter({ mapInfo in
                    if let address = mapInfo.address, address.contains(self.areas[index]) {
                        return true
                    }
                    return false
                })
            }
            tableView.reloadData()
        }
    }
    
    private func sortDisance() {
        guard let currentLocation = currentLocation, mapInfos.count > 0 else { return }
        var newMapInfos:[MapInfo] = []
        newMapInfos = mapInfos.sorted(by: { mapInfo1, mapInfo2 in
            guard let coordinate1 = getLocation(mapInfo1), let coordinate2 = getLocation(mapInfo2) else { return false }
            let distance1 = coordinate1.distance(from: currentLocation)
            let distance2 = coordinate2.distance(from: currentLocation)
            return distance1 < distance2
        })
        mapInfos.removeAll()
        mapInfos.append(contentsOf: newMapInfos)
    }
    
    private func addDropDownData() {
        self.areasDropDown.dataSource.removeAll()
        self.areas.removeAll()
        var newAreaMapInfo:[MapInfo] = []
        newAreaMapInfo.append(contentsOf: self.filterMapInfos)
        
        // Create a dictionary to store area and its corresponding latitude
        var areaLatitudeDict: [String: Double] = [:]
        
        newAreaMapInfo.forEach({
            if let address = $0.address, let area = self.getAreas(address) {
                if let location = getLocation($0) {
                    if let existingLat = areaLatitudeDict[area] {
                        areaLatitudeDict[area] = max(existingLat, location.coordinate.latitude)
                    } else {
                        areaLatitudeDict[area] = location.coordinate.latitude
                    }
                }
                self.areas.append(area)
            }
        })
        self.areas = Array(Set(self.areas))
        self.areas.sort { area1, area2 in
            let lat1 = areaLatitudeDict[area1] ?? 0
            let lat2 = areaLatitudeDict[area2] ?? 0
            return lat1 > lat2
        }
        self.areas.insert("region".localized, at: 0)
        self.areasDropDown.dataSource.append(contentsOf: self.areas)
    }
    
    private func getLocation(_ mapInfo:MapInfo) -> CLLocation? {
        guard let machineLocation = mapInfo.machineLocation , let latitudeStr = machineLocation.latitude, let longitudeStr = machineLocation.longitude, let latitude = Double(latitudeStr), let longitude = Double(longitudeStr) else { return nil }
         return CLLocation(latitude: latitude, longitude: longitude)
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
            guard let data = data, statusCode == 200 else {
                showAlert(VC: self, title: "error".localized, message: errorMSG)
                return
            }
            if let mapInfos = try? JSONDecoder().decode([MapInfo].self, from: data) {
                self.mapInfos.removeAll()
                self.filterMapInfos.removeAll()
                self.areasDropDown.dataSource.removeAll()
                self.mapInfos = mapInfos
                self.sortDisanceAction()
                self.addDropDownData()
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
    
    private func filterText(_ query:String?) {
        guard let query = query else { return }
        filterMapInfos.removeAll()
        
        let newData = mapInfos.filter({
            let storeNameResult =  $0.name?.range(of: query, options: .caseInsensitive)
            let storeAddressResult = $0.address?.range(of: query, options: .caseInsensitive)
            if storeNameResult != nil || storeAddressResult != nil {
                return true
            }else{
                return false
            }
        })
        filterMapInfos.append(contentsOf: newData)

    }
    
    private func getAreas(_ address:String) -> String? {
        guard address.count > 6 else { return nil }
        let startIndex = address.index(address.startIndex, offsetBy: 0)
        let endIndex = address.index(address.startIndex, offsetBy: 6)
        return String(address[startIndex..<endIndex])
    }
    
    @objc private func textFieldDidChange(_ textfield:UITextField) {
        if let text = textfield.text, text != "" {
            filterText(text)
        } else {
            filterMapInfos.removeAll()
            filterMapInfos.append(contentsOf: mapInfos)
        }
        tableView.reloadData()
    }
    
    @IBAction func goToStoreList(_ sender:UIButton) {
        if let navigationController = self.navigationController, let VC = UIStoryboard(name: "SiteList", bundle: Bundle.main).instantiateViewController(identifier: "SiteList") as? SiteListVC {
            pushVC(targetVC: VC, navigation: navigationController)
        }
    }
    
    @IBAction func choseArea(_ tap:UITapGestureRecognizer) {
        areasDropDown.show()
    }

}


extension StationListVC: UITableViewDelegate {
    
}

extension StationListVC: SkeletonTableViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        StationListTableViewCell.identifier
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, skeletonCellForRowAt indexPath: IndexPath) -> UITableViewCell? {
        nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filterMapInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StationListTableViewCell.identifier, for: indexPath) as! StationListTableViewCell
        let mapInfo = filterMapInfos[indexPath.row]
        cell.setCell(mapInfo, currentLocation)
        return cell
    }
    
}

extension StationListVC:CLLocationManagerDelegate {
    
    //Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            currentLocation = location
            locationManager.stopUpdatingLocation()
            sortDisanceAction()
        }
    }

}
