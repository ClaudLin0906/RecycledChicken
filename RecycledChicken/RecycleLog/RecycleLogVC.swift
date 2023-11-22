//
//  RecycleLogVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/9.
//

import UIKit
import DropDown
import SkeletonView
class RecycleLogVC: CustomVC {
    
    private struct RecycleLogInfo {
        var time:Date
        var battery:Int = 0
        var bottle:Int = 0
    }
    
    @IBOutlet weak var monthBtn:CommonImageButton!
    
    @IBOutlet weak var tableView:UITableView!
    
    private let amountDropDown = DropDown()
        
    private var recycleLogInfos:[RecycleLogInfo] = []

    private var filterUseRecordInfos:[RecycleLogInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "回收紀錄"
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit(){
        tableView.setSeparatorLocation()
        tableView.startSkeletonAnimation()
        monthBtn.newImageView.tintColor = CommonColor.shared.color1
        setupAmountDropDown()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultNavigationBackBtn()
        getRecycleLogData()        
    }
    
    private func getRecycleLogData(){
        guard let dateLastYear = dateLastYearSameDay(), let startTime = dateFromStringISO8601(date: dateLastYear).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let endTime = dateFromStringISO8601(date: Date()).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let urlStr = APIUrl.domainName + APIUrl.useRecord + "?startTime=\(startTime.replacingOccurrences(of: "+", with: "%2B"))&endTime=\(endTime.replacingOccurrences(of: "+", with: "%2B"))"
        NetworkManager.shared.getJSONBody(urlString: urlStr, authorizationToken: CommonKey.shared.authToken) { (data, statusCode, errorMSG) in
            guard statusCode == 200 else {
                showAlert(VC: self, title: "發生錯誤", message: errorMSG, alertAction: nil)
                return
            }
            if let data = data, let dic = try! JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [Any] {
                let useRecordInfos = try! JSONDecoder().decode([UseRecordInfo].self, from: JSONSerialization.data(withJSONObject: dic))
                self.useRecordInfoHandle(useRecordInfos)
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
    
    private func useRecordInfoHandle(_ data:[UseRecordInfo]) {
        
        var integratedDict: [Date: (battery: Int, bottle: Int)] = [:]
        
        for datum in data {
            if let date = dateFromString(datum.time){
                let dayComponent = Calendar.current.startOfDay(for: date)
                if var existingValues = integratedDict[dayComponent] {
                    existingValues.battery += datum.battery ?? 0
                    existingValues.bottle += datum.bottle ?? 0
                    integratedDict[dayComponent] = existingValues
                } else {
                    integratedDict[dayComponent] = (battery: datum.battery ?? 0, bottle: datum.bottle ?? 0)
                }
            }
        }
        
        for dateKey in integratedDict.keys {
            if let info = integratedDict[dateKey] {
                var recycleLogInfo = RecycleLogInfo(time: dateKey)
                if info.battery > 0 {
                    recycleLogInfo.battery = info.battery
                    recycleLogInfos.append(recycleLogInfo)
                }
                if info.bottle > 0 {
                    recycleLogInfo.bottle = info.bottle
                    recycleLogInfos.append(recycleLogInfo)
                }
            }
        }
        recycleLogInfos.sort{$0.time < $1.time }
        filterUseRecordInfos = recycleLogInfos
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
            filterUseRecordInfos = recycleLogInfos.filter({ info in
                if index == 0 {
                    return true
                }
                return Calendar.current.component(.month, from: getDates(i: 0, currentDate: info.time).2) == index
            })
            tableView.reloadData()
        }
    }
    
    @IBAction func changeAmount(_ sender: UIButton) {
        amountDropDown.show()
    }

}

extension RecycleLogVC: UITableViewDelegate, SkeletonTableViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        RecycleLogTableViewCell.identifier
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filterUseRecordInfos.count
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, skeletonCellForRowAt indexPath: IndexPath) -> UITableViewCell? {
        nil
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
        if info.bottle > 0 {
            cell.setCell(info.time, bottle: info.bottle, battery: nil)
            return cell
        }
        if info.battery > 0 {
            cell.setCell(info.time, bottle: nil, battery: info.battery)
            return cell
        }
        return cell
    }
    
}
