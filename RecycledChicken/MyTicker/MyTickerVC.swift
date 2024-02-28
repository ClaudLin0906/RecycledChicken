//
//  MyTickerVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/11.
//

import UIKit

class MyTickerVC: CustomVC {
    
    @IBOutlet weak var segmentedControl:CustomSegmentedControl!
    
    @IBOutlet weak var lotteryTableView:UITableView!

    private var myTickertInfos:[MyTickertInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "我的票夾"
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit() {
        segmentedControl.type = .singleType
        segmentedControl.setButtonTitles(MyTickertTitles)
        segmentedControl.delegate = self
        lotteryTableView.setSeparatorLocation()
    }
    
    private func getLotteryData() {
        NetworkManager.shared.getJSONBody(urlString: APIUrl.domainName + APIUrl.checkLotteryRecord, authorizationToken: CommonKey.shared.authToken) { (data, statusCode, errorMSG) in
            guard statusCode == 200 else {
                showAlert(VC: self, title: "發生錯誤", message: errorMSG, alertAction: nil)
                return
            }
            if let data = data, let dic = try! JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [Any] {
                self.myTickertInfos = try! JSONDecoder().decode([MyTickertInfo].self, from: JSONSerialization.data(withJSONObject: dic))
                DispatchQueue.main.async {
                    self.lotteryTableView.reloadData()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultNavigationBackBtn2()
        getLotteryData()
    }


}

extension MyTickerVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        view.safeAreaLayoutGuide.layoutFrame.height * 0.22
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        myTickertInfos.count
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyTickerTableViewCell.identifier, for: indexPath) as! MyTickerTableViewCell
//        cell.setCell(myTickertInfos[indexPath.row])
        return cell
    }
    
}


extension MyTickerVC: CustomSegmentedControlDelegate {
    
    func change(to index: Int) {
//        for tableView in tableViews {
//            let tag = tableView?.tag
//            if tag == index {
//                tableView?.isHidden = false
//            }
//            if tag != index {
//                tableView?.isHidden = true
//            }
//        }
    }
    
}
