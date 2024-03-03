//
//  StoreListVC.swift
//  RecycledChicken
//
//  Created by Claud on 2023/5/12.
//

import UIKit
import SkeletonView

class StoreListVC: CustomVC {
    
    @IBOutlet weak var storeListTableView:UITableView!
    
    @IBOutlet weak var searchView:SearchView!
    
    private var mapInfos:[MapInfo] = []
    
    private var filterMapInfos:[MapInfo] = []
    
    private var filtered = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "門市列表"
        UIInit()
        getStoreInfo()
        // Do any additional setup after loading the view.
    }
    
    private func getStoreInfo(){
        NetworkManager.shared.getJSONBody(urlString: APIUrl.domainName+APIUrl.machineStatus, authorizationToken: CommonKey.shared.authToken) { (data, statusCode, errorMSG) in
            guard statusCode == 200 else {
                showAlert(VC: self, title: "發生錯誤", message: errorMSG, alertAction: nil)
                return
            }
            
            if let data = data, let mapInfos = try? JSONDecoder().decode([MapInfo].self, from: data) {
                self.mapInfos = mapInfos
                DispatchQueue.main.async {
                    self.storeListTableView.reloadData()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        self.storeListTableView.stopSkeletonAnimation()
                        self.view.hideSkeleton()
                    })
                }
            }
        }
    }
    
    private func UIInit(){
        storeListTableView.setSeparatorLocation()
        searchView.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        storeListTableView.showAnimatedSkeleton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultNavigationBackBtn2()
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
        
        if !filterMapInfos.isEmpty || searchView.textField.text != ""{
            filtered = true
        }else{
            filtered = false
        }

    }
    
    @objc private func textFieldDidChange(_ textfield:UITextField) {
        if let text = textfield.text {
            filterText(text)
        }
    }
    
    private func getTableViewCount() -> Int {
        if !filterMapInfos.isEmpty {
            return filterMapInfos.count
        }
        return  filtered ? 0 : mapInfos.count
    }


}

extension StoreListVC:UITableViewDelegate, SkeletonTableViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        StoreListTableViewCell.identifier
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        40
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        getTableViewCount()
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, skeletonCellForRowAt indexPath: IndexPath) -> UITableViewCell? {
        nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        getTableViewCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StoreListTableViewCell.identifier, for: indexPath) as! StoreListTableViewCell
        let mapInfo:MapInfo = filtered ? filterMapInfos[indexPath.row] : mapInfos[indexPath.row]
        cell.setCell(mapInfo: mapInfo)
        return cell
    }
    
}
