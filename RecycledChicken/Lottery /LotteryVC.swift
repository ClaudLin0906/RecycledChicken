//
//  LotteryVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/10.
//

import UIKit
import SkeletonView

class LotteryVC: CustomVC {
    
    @IBOutlet weak var lotteryTableView:UITableView!
    
    @IBOutlet weak var activityVoucherTableView:UITableView!
        
    @IBOutlet weak var partnerMerchantsTableView:UITableView!
    
    @IBOutlet weak var segmentedControl:CustomSegmentedControl!
    
    private var lotteryInfos:[LotteryInfo] = []
    
    private var activityVoucherInfos:[LotteryInfo] = []
    
    private var partnerMerchantsInfos:[LotteryInfo] = []
    
    private lazy var tableViews = [lotteryTableView, activityVoucherTableView, partnerMerchantsTableView]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "activitiesLuckyDraws".localized
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit(){
        segmentedControl.type = .singleType
        segmentedControl.setButtonTitles(LotterySegmentedControlTitles)
        segmentedControl.delegate = self
        lotteryTableView.setSeparatorLocation()
        activityVoucherTableView.setSeparatorLocation()
        partnerMerchantsTableView.setSeparatorLocation()
        lotteryTableView.showAnimatedSkeleton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultNavigationBackBtn2()
        getLotteryData()
    }
    
    private func getLotteryData() {
        NetworkManager.shared.getJSONBody(urlString: APIUrl.domainName + APIUrl.checkLotteryItem, authorizationToken: CommonKey.shared.authToken) { (data, statusCode, errorMSG) in
            guard let data = data, statusCode == 200 else {
                showAlert(VC: self, title: "error".localized, message: errorMSG)
                return
            }
            if let lotteryInfos = try? JSONDecoder().decode([LotteryInfo].self, from: data) {
                self.lotteryInfos.removeAll()
                self.activityVoucherInfos.removeAll()
                self.partnerMerchantsInfos.removeAll()
                lotteryInfos.forEach { lotteryInfo in
                    guard let category = lotteryInfo.category else { return }
                    switch category {
                    case .ticket:
                        self.lotteryInfos.append(lotteryInfo)
                    case .event:
                        self.activityVoucherInfos.append(lotteryInfo)
                    case .partner:
                        self.partnerMerchantsInfos.append(lotteryInfo)
                    }
                }
                DispatchQueue.main.async {
                    self.lotteryTableView.reloadData()
                    self.activityVoucherTableView.reloadData()
                    self.partnerMerchantsTableView.reloadData()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        self.lotteryTableView.stopSkeletonAnimation()
                        self.activityVoucherTableView.stopSkeletonAnimation()
                        self.partnerMerchantsTableView.stopSkeletonAnimation()
                        self.view.hideSkeleton()
                    })
                }
            }
        }
    }
    
    private func getNumberOfRowsInSection(_ tableView:UITableView) -> Int {
        if tableView == lotteryTableView {
            return lotteryInfos.count
        }
        if tableView == activityVoucherTableView {
            return activityVoucherInfos.count
        }
        if tableView == partnerMerchantsTableView {
            return partnerMerchantsInfos.count
        }
        return 0
    }
    
    private func getLotteryInfo(_ tableView:UITableView, _ row:Int) -> LotteryInfo? {
        
        if tableView == lotteryTableView {
            return lotteryInfos[row]
        }
        if tableView == activityVoucherTableView {
            return activityVoucherInfos[row]
        }
        if tableView == partnerMerchantsTableView {
            return partnerMerchantsInfos[row]
        }
        return nil
    }
    
//    private func getCommodityVoucherInfo(_ row:Int) -> CommodityVoucherInfo? {
//        return activityVoucherInfos[row]
//    }
}

extension LotteryVC: SkeletonTableViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        LotteryTableViewCell.identifier
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        getNumberOfRowsInSection(skeletonView)
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, skeletonCellForRowAt indexPath: IndexPath) -> UITableViewCell? {
        nil
    }
    
}

extension LotteryVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard CurrentUserInfo.shared.isGuest == false else { return }
        if tableView == lotteryTableView {
            if let navigationController = self.navigationController, let VC = UIStoryboard(name: "BuyLottery", bundle: Bundle.main).instantiateViewController(identifier: "BuyLottery") as? BuyLotteryVC {
                VC.lotteryInfo = lotteryInfos[indexPath.row]
                pushVC(targetVC: VC, navigation: navigationController)
            }
        }

//        if tableView == activityVoucherTableView || tableView == partnerMerchantsTableView  {
//            if let navigationController = self.navigationController, let VC = UIStoryboard(name: "BuyCommodity", bundle: Bundle.main).instantiateViewController(identifier: "BuyCommodity") as? BuyCommodityVC {
//                VC.commodityVoucherInfo = activityVoucherInfos[indexPath.row]
//                pushVC(targetVC: VC, navigation: navigationController)
//            }
//        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        getNumberOfRowsInSection(tableView)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == lotteryTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: LotteryTableViewCell.identifier, for: indexPath) as! LotteryTableViewCell
            let row = indexPath.row
            if let lotteryInfo = getLotteryInfo(tableView,row) {
                cell.setCell(lotteryInfo)
            }
            return cell
        }
        
        if tableView == activityVoucherTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: ActivityVoucherTableViewCell.identifier, for: indexPath) as! ActivityVoucherTableViewCell
            let row = indexPath.row
            if let lotteryInfo = getLotteryInfo(tableView,row) {
                cell.setCell(lotteryInfo)
            }
            return cell
        }
        
        if tableView == partnerMerchantsTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: PartnerMerchantsTableViewTableViewCell.identifier, for: indexPath) as! PartnerMerchantsTableViewTableViewCell
            let row = indexPath.row
            if let lotteryInfo = getLotteryInfo(tableView,row) {
                cell.setCell(lotteryInfo)
            }
            return cell
        }
        
        return UITableViewCell()
    }
    
}

extension LotteryVC: CustomSegmentedControlDelegate {
    
    func change(to index: Int) {
        for tableView in tableViews {
            let tag = tableView?.tag
            if tag == index {
                tableView?.isHidden = false
            }
            if tag != index {
                tableView?.isHidden = true
            }
        }
    }
    
}
