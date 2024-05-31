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
    
    private var currentLocation: CLLocation?
    {
        willSet {
            if newValue != nil {
                sortDisance()
                addDropDownData()
                tableView.reloadData()
            }
        }
    }
    
    private let areasDropDown = DropDown()

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
        areasDropDown.selectionAction = { [self] (index, item) in
            dropDownView.setDefaultTitle(areas[index])
            filterMapInfos.removeAll()
            filterMapInfos = mapInfos.filter({ mapInfo in
                if let address = mapInfo.address, address.contains(areas[index]) {
                    return true
                }
                return false
            })
            tableView.reloadData()
        }
    }
    
    private func sortDisance() {
        guard let currentLocation = currentLocation else { return }
        var newMapInfos:[MapInfo] = []
        newMapInfos = mapInfos.sorted(by: { mapInfo1, mapInfo2 in
            guard let coordinate1 = getLocation(mapInfo1), let coordinate2 = getLocation(mapInfo2) else { return false }
            let distance1 = coordinate1.distance(from: currentLocation)
            let distance2 = coordinate2.distance(from: currentLocation)
            return distance1 > distance2
        })
        if newMapInfos.count > 5 {
            mapInfos.append(contentsOf: newMapInfos.prefix(5))
        }
        if newMapInfos.count <= 5 {
            mapInfos.append(contentsOf: newMapInfos)
        }
        print(" end \(mapInfos)")
    }
    
    private func addDropDownData() {
        self.areasDropDown.dataSource.removeAll()
        var newAreaMapInfo:[MapInfo] = []
        if self.filterMapInfos.count > 5 {
            newAreaMapInfo.append(contentsOf: self.filterMapInfos.prefix(5))
        }else{
            newAreaMapInfo.append(contentsOf: self.filterMapInfos)
        }
        newAreaMapInfo.forEach({
            if let address = $0.address, let area = self.getAreas(address) {
                self.areas.append(area)
            }
        })
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
                self.filterMapInfos.append(contentsOf: mapInfos)
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
        let startIndex = address.index(address.startIndex, offsetBy: 3)
        let endIndex = address.index(address.startIndex, offsetBy: 6)
        return String(address[startIndex..<endIndex])
    }
    
    @objc private func textFieldDidChange(_ textfield:UITextField) {
        if let text = textfield.text, text != "" {
            filterText(text)
        } else {
            filterMapInfos.append(contentsOf: mapInfos)
        }
        tableView.reloadData()
    }
    
    private func getNumberOfRowsInSection() -> Int {
        if filterMapInfos.count > 5 {
            return 5
        }
        return filterMapInfos.count
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
        getNumberOfRowsInSection()
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
        }
    }

}
