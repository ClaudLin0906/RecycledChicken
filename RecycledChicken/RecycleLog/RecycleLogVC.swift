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
        getRecords(nil, startTime, endTime) { result in
            switch result {
            case .success(let records):
                self.useRecordInfoHandle(records.useRecordInfos)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.tableView.stopSkeletonAnimation()
                        self.view.hideSkeleton()
                    }
                }
            case .failure:
                showAlert(VC: self, title: "error".localized)
            }
        }
    }
    
    private func useRecordInfoHandle(_ data:[UseRecordInfo]) {
        typealias DayTotals = (battery: Int, bottle: Int, coloredBottle: Int, colorlessBottle: Int, can: Int, cup: Int, hdpeBottle: Int, foilPack: Int, cartonBox: Int)
        var integratedDict: [Date: DayTotals] = [:]

        data.forEach { datum in
            guard let datmTime = datum.time, let date = dateFromString(datmTime) else { return }
            let dayComponent = Calendar.current.startOfDay(for: date)
            let d = datum.recycleDetails
            if var e = integratedDict[dayComponent] {
                e.battery      += d?.battery      ?? 0
                e.bottle       += d?.bottle       ?? 0
                e.coloredBottle   += d?.coloredBottle   ?? 0
                e.colorlessBottle += d?.colorlessBottle ?? 0
                e.can          += d?.can          ?? 0
                e.cup          += d?.cup          ?? 0
                e.hdpeBottle   += d?.hdpeBottle   ?? 0
                e.foilPack     += d?.foilPack     ?? 0
                e.cartonBox    += d?.cartonBox    ?? 0
                integratedDict[dayComponent] = e
            } else {
                integratedDict[dayComponent] = (
                    battery:      d?.battery      ?? 0,
                    bottle:       d?.bottle       ?? 0,
                    coloredBottle:   d?.coloredBottle   ?? 0,
                    colorlessBottle: d?.colorlessBottle ?? 0,
                    can:          d?.can          ?? 0,
                    cup:          d?.cup          ?? 0,
                    hdpeBottle:   d?.hdpeBottle   ?? 0,
                    foilPack:     d?.foilPack     ?? 0,
                    cartonBox:    d?.cartonBox    ?? 0
                )
            }
        }

        integratedDict.keys.forEach { dateKey in
            guard let info = integratedDict[dateKey] else { return }
            if info.battery > 0 {
                var log = RecycleLogInfo(time: dateKey); log.battery = info.battery
                recycleLogInfos.append(log)
            }
            if info.bottle > 0 || info.coloredBottle > 0 || info.colorlessBottle > 0 {
                var log = RecycleLogInfo(time: dateKey)
                log.bottle = info.bottle + info.coloredBottle + info.colorlessBottle
                recycleLogInfos.append(log)
            }
            if info.can > 0 {
                var log = RecycleLogInfo(time: dateKey); log.can = info.can
                recycleLogInfos.append(log)
            }
            if info.cup > 0 {
                var log = RecycleLogInfo(time: dateKey); log.cup = info.cup
                recycleLogInfos.append(log)
            }
            if info.hdpeBottle > 0 {
                var log = RecycleLogInfo(time: dateKey); log.hdpeBottle = info.hdpeBottle
                recycleLogInfos.append(log)
            }
            if info.foilPack > 0 {
                var log = RecycleLogInfo(time: dateKey); log.foilPack = info.foilPack
                recycleLogInfos.append(log)
            }
            if info.cartonBox > 0 {
                var log = RecycleLogInfo(time: dateKey); log.cartonBox = info.cartonBox
                recycleLogInfos.append(log)
            }
        }
        recycleLogInfos.sort { $0.time > $1.time }
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
        
        amountDropDown.selectionAction = { [weak self] (index, item) in
            self?.monthBtn.setTitle(item)
            self?.filterUseRecordInfos.removeAll()
            self?.filterUseRecordInfos = self?.recycleLogInfos.filter({ info in
                if index == 0 {
                    return true
                }
                return Calendar.current.component(.month, from: getDates(i: 0, currentDate: info.time).2) == index
            }) ?? []
            self?.tableView.reloadData()
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
        if info.bottle > 0 || info.colorlessBottle > 0 || info.coloredBottle > 0 {
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
