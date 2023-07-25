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
    
    private let amountDropDown = DropDown()
    
    private var useRecordInfos:[UseRecordInfo] = []

    private var filterUseRecordInfos:[UseRecordInfo] = []
    
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultNavigationBackBtn()
        getRecycleLogData()        
    }
    
    private func getRecycleLogData(){
        guard let dateLastYear = dateLastYearSameDay() else { return }
        let urlStr = APIUrl.domainName + APIUrl.useRecord + "?startTime=\(dateFromStringISO8601(date: dateLastYear))&endTime=\(dateFromStringISO8601(date: Date()))"
        NetworkManager.shared.getJSONBody(urlString: urlStr, authorizationToken: CommonKey.shared.authToken) { (data, statusCode, errorMSG) in
            guard statusCode == 200 else {
                showAlert(VC: self, title: "發生錯誤", message: errorMSG, alertAction: nil)
                return
            }
            if let data = data, let dic = try! JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [Any] {
                self.useRecordInfos = try! JSONDecoder().decode([UseRecordInfo].self, from: JSONSerialization.data(withJSONObject: dic))
                self.filterUseRecordInfos = self.useRecordInfos
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
        
        amountDropDown.selectionAction = { [self] (index, item) in
            monthBtn.setTitle(item)
            filterUseRecordInfos.removeAll()
            filterUseRecordInfos = useRecordInfos.filter({ info in
                if index == 0 {
                    return true
                }
                return timeGetMon(dateStr: info.time) == index
            })
            tableView.reloadData()
        }
    }
    
    
    @IBAction func changeAmount(_ sender: UIButton) {
        amountDropDown.show()
    }
    
    private func timeGetMon(dateStr:String)->Int? {
        if let date = dateFromString(dateStr){
            return Calendar.current.component(.month, from: date)
        }
        return nil
    }

}

extension RecycleLogVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filterUseRecordInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecycleLogTableViewCell.identifier, for: indexPath) as! RecycleLogTableViewCell
        let info = filterUseRecordInfos[indexPath.row]
        cell.setCell(info: info)
        return cell
    }
    
}
