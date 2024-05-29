//
//  CommodityVoucherVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/10.
//

import UIKit
import SkeletonView

class CommodityVoucherVC: CustomVC {
    
    @IBOutlet weak var tableView:UITableView!
    
    private var commodityVoucherInfos:[CommodityVoucherInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "coupon".localized
        UIInit()
        
        // Do any additional setup after loading the view.
    }
    
    private func UIInit(){
        tableView.setSeparatorLocation()
        tableView.showAnimatedSkeleton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultNavigationBackBtn2()
        getCouponsData()
    }
    
    private func getCouponsData() {
        NetworkManager.shared.getJSONBody(urlString: APIUrl.domainName + APIUrl.coupons, authorizationToken: CommonKey.shared.authToken) { [self] data, statusCode, errorMSG in
            guard let data = data, statusCode == 200 else {
                showAlert(VC: self, title: "error".localized, message: errorMSG)
                return
            }
            commodityVoucherInfos.removeAll()
            if let commodityVoucherResponse = try? JSONDecoder().decode([CommodityVoucherInfo].self, from: data) {
                commodityVoucherResponse.forEach { commodityVoucherInfo in
                    guard let category = commodityVoucherInfo.category else { return }
                    switch category {
                    case .ticket:
                        commodityVoucherInfos.append(commodityVoucherInfo)
                    default:
                        break
                    }
                }
                DispatchQueue.main.async { [self] in
                    tableView.reloadData()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [self] in
                        tableView.stopSkeletonAnimation()
                        view.hideSkeleton()
                    })
                }
            }
        }
    }
}

extension CommodityVoucherVC: SkeletonTableViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        CommodityVoucherTableViewCell.identifier
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        commodityVoucherInfos.count
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, skeletonCellForRowAt indexPath: IndexPath) -> UITableViewCell? {
        nil
    }
    
}

extension CommodityVoucherVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let navigationController = self.navigationController, let VC = UIStoryboard(name: "BuyCommodity", bundle: Bundle.main).instantiateViewController(identifier: "BuyCommodity") as? BuyCommodityVC {
            VC.commodityVoucherInfo = commodityVoucherInfos[indexPath.row]
            pushVC(targetVC: VC, navigation: navigationController)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        commodityVoucherInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommodityVoucherTableViewCell.identifier, for: indexPath) as! CommodityVoucherTableViewCell
        cell.setCell(commodityVoucherInfos[indexPath.row])
        return cell
    }
    
}
