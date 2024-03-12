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

    private var myTickertInfos:[MyTickertInfo] = []
    
    private var voucherInfos:[MyTickertInfo] = []
    
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
        NetworkManager.shared.getJSONBody(urlString: APIUrl.domainName + APIUrl.checkLotteryRecord, authorizationToken: CommonKey.shared.authToken) { (data, statusCode, errorMSG) in
            guard statusCode == 200 else {
                showAlert(VC: self, title: "error".localized, message: errorMSG, alertAction: nil)
                return
            }
            if let data = data, let dic = try! JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [Any] {
                self.voucherInfos = try! JSONDecoder().decode([MyTickertInfo].self, from: JSONSerialization.data(withJSONObject: dic))
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
        NetworkManager.shared.getJSONBody(urlString: APIUrl.domainName + APIUrl.checkLotteryRecord, authorizationToken: CommonKey.shared.authToken) { (data, statusCode, errorMSG) in
            guard statusCode == 200 else {
                showAlert(VC: self, title: "error".localized, message: errorMSG, alertAction: nil)
                return
            }
            if let data = data, let dic = try! JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [Any] {
                self.myTickertInfos = try! JSONDecoder().decode([MyTickertInfo].self, from: JSONSerialization.data(withJSONObject: dic))
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
//            return myTickertInfos.count
            return 3
        }
        if tableView == voucherTableView {
//            return voucherInfos.count
            return 3
        }
        return 0
    }

}

extension MyTickerVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        view.safeAreaLayoutGuide.layoutFrame.height * 0.22
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        getNumberOfRowsInSection(tableView)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == lotteryTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: MyTickerTableViewCell.identifier, for: indexPath) as! MyTickerTableViewCell
    //        cell.setCell(myTickertInfos[indexPath.row])
            return cell
        }
        
        if tableView == voucherTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: MyTickerVoucherTableViewCell.identifier, for: indexPath) as! MyTickerVoucherTableViewCell
    //        cell.setCell(myTickertInfos[indexPath.row])
            return cell
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
