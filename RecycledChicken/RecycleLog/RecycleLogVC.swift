//
//  RecycleLogVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/9.
//

import UIKit
import DropDown

class RecycleLogVC: CustomVC {
    
    @IBOutlet weak var monthBtn:CommonImageButton!
    
    @IBOutlet weak var tableView:UITableView!
    
    let amountDropDown = DropDown()
    
    var recycleLogInfos:[RecycleLogInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "回收紀錄"
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit(){
        tableView.setSeparatorLocation()
        monthBtn.newImageView.tintColor = CommonColor.shared.color1
        setupAmountDropDown()
        getRecycleLogData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultNavigationBackBtn()
    }
    
    private func getRecycleLogData(){
        NetworkManager.shared.getJSONBody(urlString: APIUrl.domainName + APIUrl.useRecord, authorizationToken: CommonKey.shared.authToken) { (data, statusCode, errorMSG) in
            guard statusCode == 200 else {
                showAlert(VC: self, title: "發生錯誤", message: errorMSG, alertAction: nil)
                return
            }
            if let data = data {
                self.recycleLogInfos = try! JSONDecoder().decode([RecycleLogInfo].self, from: data)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    private func setupAmountDropDown() {
        monthBtn.setTitle("所有月份")
        amountDropDown.anchorView = monthBtn
        amountDropDown.bottomOffset = CGPoint(x: 0, y: monthBtn.bounds.height)
        
        amountDropDown.dataSource =
        [
            "所有月份",
            "1月",
            "2月",
            "3月",
            "4月",
            "5月",
            "6月",
            "7月",
            "8月",
            "9月",
            "10月",
            "11月",
            "12月"
        ]
        
        amountDropDown.selectionAction = { [weak self] (index, item) in
            self?.monthBtn.setTitle(item)
        }
    }
    
    
    @IBAction func changeAmount(_ sender: UIButton) {
        amountDropDown.show()
    }

}

extension RecycleLogVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("123")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recycleLogInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecycleLogTableViewCell.identifier, for: indexPath) as! RecycleLogTableViewCell
        return cell
    }
    
}
