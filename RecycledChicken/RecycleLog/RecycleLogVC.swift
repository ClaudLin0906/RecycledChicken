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
        
    @IBOutlet weak var monthBtn:CommonImageButton!
    
    @IBOutlet weak var monthBtnWidth:NSLayoutConstraint!
    
    @IBOutlet weak var tableView:UITableView!
    
    private let amountDropDown = DropDown()
        
    private var recycleLogInfos:[RecycleLogInfo] = []

    private var filterUseRecordInfos:[RecycleLogInfo] = []
    
    private var allMonth = "allMonth".localized
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "recycleLog".localized
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit(){
        tableView.setSeparatorLocation()
        tableView.startSkeletonAnimation()
        monthBtn.newImageView.tintColor = CommonColor.shared.color1
        setupAmountDropDown()
        if getLanguage() == .english {
            monthBtnWidth.constant = 150
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultNavigationBackBtn()
        getRecycleLogData()        
    }
    
    private func getRecycleLogData() {
        guard let dateLastYear = dateLastYearSameDay() else { return }
        let startTime = dateFromStringISO8601(date: dateLastYear)
        let endTime = dateFromStringISO8601(date: Date())
        getRecords(nil, startTime, endTime) { statusCode, errorMSG, useRecordInfos, battery, bottle, colorledBottle, colorlessBottle, can, cup in
            guard let statusCode = statusCode, statusCode == 200 else {
                showAlert(VC: self, title: "error".localized)
                return
            }
            if let useRecordInfos = useRecordInfos {
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
        
        var integratedDict: [Date: (battery: Int, bottle: Int, coloredBottle:Int, colorlessBottle: Int, can: Int)] = [:]
        
        data.forEach { datum in
            if let datmTime = datum.time, let date = dateFromString(datmTime) {
                let dayComponent = Calendar.current.startOfDay(for: date)
                if var existingValues = integratedDict[dayComponent] {
                    existingValues.battery += datum.recycleDetails?.battery ?? 0
                    existingValues.bottle += datum.recycleDetails?.bottle ?? 0
                    existingValues.colorlessBottle += datum.recycleDetails?.colorlessBottle ?? 0
                    existingValues.coloredBottle += datum.recycleDetails?.coloredBottle ?? 0
                    existingValues.can += datum.recycleDetails?.can ?? 0
                    integratedDict[dayComponent] = existingValues
                } else {
                    integratedDict[dayComponent] = (battery: datum.recycleDetails?.battery ?? 0, bottle: datum.recycleDetails?.bottle ?? 0, coloredBottle:datum.recycleDetails?.coloredBottle ?? 0, colorlessBottle: datum.recycleDetails?.colorlessBottle ?? 0, datum.recycleDetails?.can ?? 0)
                }
            }
        }
        
        integratedDict.keys.forEach { dateKey in
            if let info = integratedDict[dateKey] {
                if info.battery > 0 {
                    var recycleLogInfo = RecycleLogInfo(time: dateKey)
                    recycleLogInfo.battery = info.battery
                    recycleLogInfos.append(recycleLogInfo)
                }
                if info.bottle > 0 || info.coloredBottle > 0 || info.colorlessBottle > 0 {
                    var recycleLogInfo = RecycleLogInfo(time: dateKey)
                    let count = info.bottle + info.coloredBottle + info.coloredBottle
                    recycleLogInfo.bottle = count
                    recycleLogInfos.append(recycleLogInfo)
                }
                if info.can > 0 {
                    var recycleLogInfo = RecycleLogInfo(time: dateKey)
                    recycleLogInfo.can = info.can
                    recycleLogInfos.append(recycleLogInfo)
                }
            }
        }
        recycleLogInfos.sort{$0.time < $1.time }
        filterUseRecordInfos = recycleLogInfos
    }
    
    private func setupAmountDropDown() {
        monthBtn.setTitle(allMonth)
        amountDropDown.anchorView = monthBtn
        amountDropDown.bottomOffset = CGPoint(x: 0, y: monthBtn.bounds.height)
        
        amountDropDown.dataSource =
        [
            allMonth,
            "jan".localized,
            "feb".localized,
            "mar".localized,
            "apr".localized,
            "may".localized,
            "jun".localized,
            "jul".localized,
            "aug".localized,
            "sep".localized,
            "oct".localized,
            "nov".localized,
            "dec".localized,
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filterUseRecordInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecycleLogTableViewCell.identifier, for: indexPath) as! RecycleLogTableViewCell
        let info = filterUseRecordInfos[indexPath.row]
        if info.bottle > 0 || info.colorlessBottle > 0 || info.coloredBottle > 0{
            let count = info.bottle + info.colorlessBottle + info.coloredBottle
            cell.setCell(info.time, bottle: count, battery: nil, can: nil)
            return cell
        }
        if info.battery > 0 {
            cell.setCell(info.time, bottle: nil, battery: info.battery, can: nil)
            return cell
        }
        if info.can > 0 {
            cell.setCell(info.time, bottle: nil, battery: nil, can: info.can)
            return cell
        }
        return cell
    }
    
}
