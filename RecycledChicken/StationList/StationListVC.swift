//
//  StationListVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2024/3/3.
//

import UIKit
import DropDown
import SkeletonView
class StationListVC: CustomVC {
    
    @IBOutlet weak var dropDownView:DropDownView!
    
    @IBOutlet weak var keyWordTextfiekd:UITextField!
    
    @IBOutlet weak var tableView:UITableView!
    
    private var mapInfos:[MapInfo] = []
    
    private var filterMapInfos:[MapInfo] = []
    
    private var filtered = false

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "站點列表"
        UIInit()
        getStoreInfo()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit() {
        dropDownView.changeType(.darkColor)
        dropDownView.setDefaultTitle("地區選擇")
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultNavigationBackBtn2()
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
        if let navigationController = self.navigationController, let VC = UIStoryboard(name: "StoreList", bundle: Bundle.main).instantiateViewController(identifier: "StoreList") as? StoreListVC {
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
