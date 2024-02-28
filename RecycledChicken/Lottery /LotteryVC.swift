//
//  LotteryVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/10.
//

import UIKit
import SkeletonView

class LotteryVC: CustomVC {
    
    @IBOutlet weak var tableView:UITableView!
    
    @IBOutlet weak var segmentedControl:CustomSegmentedControl!
    
    private var lotteryInfos:[LotteryInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "活動抽獎專區"
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit(){
        segmentedControl.type = .singleType
        segmentedControl.setButtonTitles(LotterySegmentedControlTitles)
        tableView.setSeparatorLocation()
        tableView.showAnimatedSkeleton()
    }
    
    private func getData(){
        NetworkManager.shared.getJSONBody(urlString: APIUrl.domainName + APIUrl.checkLotteryItem, authorizationToken: CommonKey.shared.authToken) { (data, statusCode, errorMSG) in
            guard statusCode == 200 else {
                showAlert(VC: self, title: "發生錯誤", message: errorMSG, alertAction: nil)
                return
            }
            if let data = data, let dic = try! JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [Any] {
                if let data = try? JSONDecoder().decode([LotteryInfo].self, from: JSONSerialization.data(withJSONObject: dic)) {
                    self.lotteryInfos = data.filter({ lotteryInfo in
                        if let startDate = dateFromString(lotteryInfo.activityStartTime), let endDate = dateFromString(lotteryInfo.activityEndTime), endDate > startDate {
                            let dateInterval = DateInterval(start: startDate, end: endDate)
                            return dateInterval.contains(Date())
                        }
                        return false
                    })
                }
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultNavigationBackBtn2()
        getData()
    }

}

extension LotteryVC: UITableViewDelegate, SkeletonTableViewDataSource {    
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        LotteryTableViewCell.identifier
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        lotteryInfos.count
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, skeletonCellForRowAt indexPath: IndexPath) -> UITableViewCell? {
        nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard CurrentUserInfo.shared.isGuest == false else { return }
        if let navigationController = self.navigationController, let VC = UIStoryboard(name: "BuyLottery", bundle: Bundle.main).instantiateViewController(identifier: "BuyLottery") as? BuyLotteryVC {
            VC.lotteryInfo = lotteryInfos[indexPath.row]
            pushVC(targetVC: VC, navigation: navigationController)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        lotteryInfos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LotteryTableViewCell.identifier, for: indexPath) as! LotteryTableViewCell
        let row = indexPath.row
        cell.setCell(lotteryInfo: lotteryInfos[row])
        return cell
    }
    
}
