//
//  MyTickerVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/11.
//

import UIKit
import SkeletonView
class MyTickerVC: CustomVC {
    
    @IBOutlet weak var segmentedControl:CustomSegmentedControl!
    
    @IBOutlet weak var lotteryTableView:UITableView!
    
    @IBOutlet weak var voucherTableView:UITableView!

    private var myTickertInfos:[MyTickertLotteryInfo] = []
    
    private var myVoucherInfos:[MyTickertCouponsInfo] = []
    
    private lazy var tableViews = [lotteryTableView, voucherTableView]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "myWallet".localized
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit() {
        segmentedControl.type = .singleType
        segmentedControl.setButtonTitles(MyTickertTitles)
        segmentedControl.delegate = self
        lotteryTableView.setSeparatorLocation()
        lotteryTableView.startSkeletonAnimation()
        voucherTableView.setSeparatorLocation()
    }
    
    private func getVoucherData() {
        NetworkManager.shared.getJSONBody(urlString: APIUrl.domainName + APIUrl.havingCoupons, authorizationToken: CommonKey.shared.authToken) { [weak self] data, statusCode, errorMSG in
            guard statusCode == 200, let data = data, let self = self else {
                showAlert(VC: self, title: "error".localized, message: errorMSG)
                return
            }
            if let myTickertCouponsInfos = try? JSONDecoder().decode([MyTickertCouponsInfo].self, from: data) {
                self.myVoucherInfos.removeAll()
                self.myVoucherInfos.append(contentsOf: myTickertCouponsInfos)
                DispatchQueue.main.async {
                    self.voucherTableView.reloadData()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        self.voucherTableView.stopSkeletonAnimation()
                        self.view.hideSkeleton()
                    })
                }
            }
        }
    }
    
    private func getLotteryData() {
        NetworkManager.shared.getJSONBody(urlString: APIUrl.domainName + APIUrl.havingLottery, authorizationToken: CommonKey.shared.authToken) { [weak self] (data, statusCode, errorMSG) in
            guard statusCode == 200, let self = self else {
                showAlert(VC: self, title: "error".localized, message: errorMSG)
                return
            }
            if let data = data, let myTickertLotteryInfo = try? JSONDecoder().decode([MyTickertLotteryInfo].self, from: data) {
                self.myTickertInfos.removeAll()
                self.myTickertInfos.append(contentsOf: myTickertLotteryInfo)
                DispatchQueue.main.async {
                    self.lotteryTableView.reloadData()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        self.lotteryTableView.stopSkeletonAnimation()
                        self.view.hideSkeleton()
                    })
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultNavigationBackBtn2()
        getLotteryData()
        getVoucherData()
    }
    
    private func getNumberOfRowsInSection(_ tableView:UITableView) -> Int {
        if tableView == lotteryTableView {
            return myTickertInfos.count
        }
        if tableView == voucherTableView {
            return myVoucherInfos.count
        }
        return 0
    }
    
    @IBAction func longPressAction(_ LPGesutre:UILongPressGestureRecognizer) {
        
    }

}

extension MyTickerVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        if tableView == lotteryTableView {
            
        }
        if tableView == voucherTableView {
            let myVoucherInfo = myVoucherInfos[row]
            if let partner = myVoucherInfo.partner, partner != "" {
                if let navigationController = self.navigationController, let VC = UIStoryboard(name: "CheckStoreNumber", bundle: Bundle.main).instantiateViewController(identifier: "CheckStoreNumber") as? CheckStoreNumberVC {
                    VC.myTickertCouponsInfo = myVoucherInfo
                    pushVC(targetVC: VC, navigation: navigationController)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        view.safeAreaLayoutGuide.layoutFrame.height * 0.22
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        getNumberOfRowsInSection(tableView)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == lotteryTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: MyTickerTableViewCell.identifier, for: indexPath) as! MyTickerTableViewCell
            cell.setCell(myTickertInfos[indexPath.row])
            return cell
        }
        if tableView == voucherTableView {
            let row = indexPath.row
            let myVoucherInfo = myVoucherInfos[row]
            if myVoucherInfo.link != nil {
                let cell = tableView.dequeueReusableCell(withIdentifier: MyTickerYiRuiTableViewCell.identifier, for: indexPath) as! MyTickerYiRuiTableViewCell
                cell.setCell(myVoucherInfo)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: MyTicketVoucherSerialNumberTableViewCell.identifier, for: indexPath) as! MyTicketVoucherSerialNumberTableViewCell
                cell.delegate = self
                cell.setCell(myVoucherInfo)
                return cell
            }
        }
        return UITableViewCell()
    }
    
}

extension MyTickerVC: SkeletonTableViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        if skeletonView == lotteryTableView {
            return MyTickerTableViewCell.identifier
        }
        if skeletonView == voucherTableView {
            return MyTickerVoucherTableViewCell.identifier
        }
        return ""
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        getNumberOfRowsInSection(skeletonView)
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, skeletonCellForRowAt indexPath: IndexPath) -> UITableViewCell? {
        nil
    }
    
}


extension MyTickerVC: CustomSegmentedControlDelegate {
    
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

extension MyTickerVC: MyTicketVoucherSerialNumberTableViewCellDelegate {
    func copySerialNumber(_ serialNumber: String) {
        UIPasteboard.general.string = serialNumber
        showAlert(VC: self, title: "copySuccess".localized)
    }
}
