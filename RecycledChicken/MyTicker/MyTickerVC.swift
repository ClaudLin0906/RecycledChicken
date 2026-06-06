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
        Task {
            do {
                let voucherInfos = try await fetchVoucherDataAsync()
                await MainActor.run {
                    self.myVoucherInfos = voucherInfos
                    self.reloadTableViewWithAnimation(self.voucherTableView)
                }
            } catch {
                await MainActor.run {
                    if let netError = error as? NetworkError {
                        self.handleNetworkError(netError)
                    } else {
                        showAlert(VC: self, title: "error".localized, message: error.localizedDescription)
                    }
                }
            }
        }
    }
    
    private func getLotteryData() {
        Task {
            do {
                let lotteryInfos = try await fetchLotteryDataAsync()
                await MainActor.run {
                    self.myTickertInfos = lotteryInfos
                    self.reloadTableViewWithAnimation(self.lotteryTableView)
                }
            } catch {
                await MainActor.run {
                    if let netError = error as? NetworkError {
                        self.handleNetworkError(netError)
                    } else {
                        showAlert(VC: self, title: "error".localized, message: error.localizedDescription)
                    }
                }
            }
        }
    }
    
    private func fetchLotteryDataAsync() async throws -> [MyTickertLotteryInfo] {
        try await withCheckedThrowingContinuation { continuation in
            NetworkManager.shared.get(url: APIUrl.domainName + APIUrl.havingLottery,authorizationToken: CommonKey.shared.authToken, responseType: [MyTickertLotteryInfo].self) { result in
                switch result {
                case .success(let data):
                    continuation.resume(returning: data)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    private func fetchVoucherDataAsync() async throws -> [MyTickertCouponsInfo] {
        try await withCheckedThrowingContinuation { continuation in
            NetworkManager.shared.get(url: APIUrl.domainName + APIUrl.havingCoupons, authorizationToken: CommonKey.shared.authToken, responseType: [MyTickertCouponsInfo].self) { result in
                switch result {
                case .success(let data):
                    continuation.resume(returning: data)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    private func reloadTableViewWithAnimation(_ tableView: UITableView?) {
        tableView?.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            tableView?.stopSkeletonAnimation()
            self.view.hideSkeleton()
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
                cell.delegate = self
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

extension MyTickerVC: MyTickerYiRuiTableViewCellDelegate {
    
    func button(_ sender: UIButton, info: MyTickertCouponsInfo) {
        if let navigationController = self.navigationController, let VC = UIStoryboard(name: "BuyLottery", bundle: Bundle.main).instantiateViewController(identifier: "BuyLottery") as? BuyLotteryVC {
            pushVC(targetVC: VC, navigation: navigationController)
        }
    }
}
    
