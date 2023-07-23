//
//  CommodityVoucherVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/10.
//

import UIKit

class CommodityVoucherVC: CustomVC {
    
    @IBOutlet weak var tableView:UITableView!
    
    private var commodityVoucherInfos:[CommodityVoucherInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "商品禮卷"
        UIInit()
        getData()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit(){
        
    }
    
    private func getData(){
        NetworkManager.shared.getJSONBody(urlString: APIUrl.domainName + APIUrl.checkLotteryItem, authorizationToken: CommonKey.shared.authToken) { (data, statusCode, errorMSG) in
            guard statusCode == 200 else {
                showAlert(VC: self, title: "發生錯誤", message: errorMSG, alertAction: nil)
                return
            }
            if let data = data, let dic = try! JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [Any] {
                self.commodityVoucherInfos = try! JSONDecoder().decode([CommodityVoucherInfo].self, from: JSONSerialization.data(withJSONObject: dic))
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultNavigationBackBtn2()
    }

    
}

extension CommodityVoucherVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let navigationController = self.navigationController, let VC = UIStoryboard(name: "BuyCommodity", bundle: Bundle.main).instantiateViewController(identifier: "BuyCommodity") as? BuyCommodityVC {
            VC.commodityVoucherInfo = commodityVoucherInfos[indexPath.row]
            pushVC(targetVC: VC, navigation: navigationController)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        commodityVoucherInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommodityVoucherTableViewCell.identifier, for: indexPath) as! CommodityVoucherTableViewCell
        cell.setCell(commodityVoucherInfo: commodityVoucherInfos[indexPath.row])
        return cell
    }
    
}
