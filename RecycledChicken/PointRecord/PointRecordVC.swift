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
    
    private let amountDropDown = DropDown()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "點數紀錄"
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit() {
        tableView.setSeparatorLocation()
        tableView.startSkeletonAnimation()
        monthBtn.newImageView.tintColor = CommonColor.shared.color1
        setupAmountDropDown()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultNavigationBackBtn()
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
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PointRecordTableViewCell", for: indexPath) as! PointRecordTableViewCell
        cell.setCell(Date(), content: "寶特瓶5瓶", point: -10)
        return cell
    }
    
}
