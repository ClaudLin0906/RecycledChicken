//
//  LotteryVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/10.
//

import UIKit

class LotteryVC: CustomVC {
    
    @IBOutlet weak var tableView:UITableView!
    
    private var lotteryInfos:[LotteryInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "抽獎專區"
        UIInit()
        getData()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit(){
        tableView.setSeparatorLocation()
    }
    
    private func getData(){
        NetworkManager.shared.getJSONBody(urlString: APIUrl.domainName + APIUrl.checkLotteryItem, authorizationToken: CommonKey.shared.authToken) { (data, statusCode, errorMSG) in
            guard statusCode == 200 else {
                showAlert(VC: self, title: "發生錯誤", message: errorMSG, alertAction: nil)
                return
            }
            if let data = data, let dic = try! JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [Any] {
                self.lotteryInfos = try! JSONDecoder().decode([LotteryInfo].self, from: JSONSerialization.data(withJSONObject: dic))
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

extension LotteryVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let navigationController = self.navigationController, let VC = UIStoryboard(name: "BuyLottery", bundle: Bundle.main).instantiateViewController(identifier: "BuyLottery") as? BuyLotteryVC {
            VC.lotteryInfo = lotteryInfos[indexPath.row]
            pushVC(targetVC: VC, navigation: navigationController)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
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
