//
//  PointRecordVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2024/2/25.
//

import UIKit
import DropDown
import SkeletonView

class PointRecordVC: CustomVC {
    
    @IBOutlet weak var tableView:UITableView!
    
    @IBOutlet weak var monthBtn:CommonImageButton!
    
    @IBOutlet weak var monthBtnWidth:NSLayoutConstraint!
    
    private let amountDropDown = DropDown()
    
    private var allMonth = "allMonth".localized
    
    private var pointRecords:[PointRecord] = []
    
    private var filterPointRecords:[PointRecord] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "pointRecord".localized
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit() {
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
        getPointRecord()
    }
    
    private func getPointRecord() {
        NetworkManager.shared.getJSONBody(urlString: APIUrl.domainName + APIUrl.pointRecords + "?startTime=2023-01-01", authorizationToken: CommonKey.shared.authToken) { data, statusCode, errorMSG in
            guard let data = data, statusCode == 200 else {
                showAlert(VC: self, title: "error".localized, message: errorMSG)
                return
            }
            if let pointRecords = try? JSONDecoder().decode([PointRecord].self, from: data) {
                self.pointRecords.removeAll()
                self.filterPointRecords.removeAll()
                self.pointRecords.append(contentsOf: pointRecords)
                self.filterPointRecords.append(contentsOf: pointRecords)
                self.tableView.reloadData()
            }
        }
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
            guard let self = self else { return }
            monthBtn.setTitle(item)
            filterPointRecords.removeAll()
            filterPointRecords = pointRecords.filter({ pointRecord in
                if index == 0 {
                    return true
                }
                if let dateString = pointRecord.time, let date = dateFromString(dateString) {
                    let month =  Calendar.current.component(.month, from: date)
                    return month == index
                }
                return false
            })
            tableView.reloadData()
        }
    }
    
    @IBAction func changeAmount(_ sender: UIButton) {
        amountDropDown.show()
    }
    
}

extension PointRecordVC: UITableViewDelegate {
    
}

extension PointRecordVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filterPointRecords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PointRecordTableViewCell", for: indexPath) as! PointRecordTableViewCell
        let row = indexPath.row
        cell.setCell(filterPointRecords[row])
        return cell
    }
    
}
