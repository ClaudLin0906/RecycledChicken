//
//  CarbonReductionLogVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/8.
//

import UIKit
import DropDown
import MKRingProgressView
class CarbonReductionLogVC: CustomVC {
        
    @IBOutlet weak var recycleBtn:UIButton!
    
    @IBOutlet weak var recycledRingInfoView:RecycledRingInfoView!
    
    @IBOutlet weak var dropDownView:DropDownView!
    
    @IBOutlet weak var bottleItemCellView:CarbonReductionItemCellView!
    
    @IBOutlet weak var batteryItemCellView:CarbonReductionItemCellView!
    
    @IBOutlet weak var papperCubItemCellView:CarbonReductionItemCellView!
    
    @IBOutlet weak var aluminumCanItemCellView:CarbonReductionItemCellView!
    
    @IBOutlet weak var publicTransportItemCellView:CarbonReductionItemCellView!
        
    private var recyceledSortInfos:[RecyceledSortInfo] = {
        var arr:[RecyceledSortInfo] = []
        for i in RecyceledSort.allCases {
            arr.append(i.getInfo())
        }
        return arr
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "減碳歷程"
        UIInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultNavigationBackBtn()
        getRecycleLogData()
    }

    private func UIInit() {
        recycledRingInfoView.setRecycledRingInfo(recyceledSortInfos.first!, 10, 20)
        dropDownView.sortLabel.text = recyceledSortInfos.first?.chineseName
        recycleBtn.layer.borderWidth = 1
        recycleBtn.layer.borderColor = #colorLiteral(red: 0.7647058964, green: 0.7647058964, blue: 0.7647058964, alpha: 1)
        bottleItemCellView.setType(.bottle)
        batteryItemCellView.setType(.battery)
        papperCubItemCellView.setType(.papperCub)
        aluminumCanItemCellView.setType(.aluminumCan)
        publicTransportItemCellView.setType(.publicTransport)
        recycledRingInfoView.layer.shadowOffset = CGSize(width: 1, height: 1)
        recycledRingInfoView.layer.shadowOpacity = 0.2
//        "Congratulations!\n恭喜你電池回收量\n超額完成!"
        // Do any additional setup after loading the view.
    }
    
    private func setValueOfDropDown(_ info:RecyceledSortInfo) {
        
    }
    
    @IBAction func goBuenopartners(_ sender:UIButton) {
        if let url = URL(string: "https://www.buenopartners.com.tw/formula") {
            UIApplication.shared.open(url)
        }
    }
    
    private func getRecycleLogData(){
        guard let dateLastYear = dateLastYearSameDay() else { return }
        let startTime = dateFromStringISO8601(date: dateLastYear)
        let endTime = dateFromStringISO8601(date: Date())
        let urlStr = APIUrl.domainName + APIUrl.useRecord + "?startTime=\(startTime)&endTime=\(endTime)"
        NetworkManager.shared.getJSONBody(urlString: urlStr, authorizationToken: CommonKey.shared.authToken) { (data, statusCode, errorMSG) in
            guard statusCode == 200 else {
                showAlert(VC: self, title: "error".localized, message: errorMSG)
                return
            }
            var batteryInt = 0
            var bottleInt = 0
            if let data = data, let dic = try! JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [Any] {
                let useRecordInfos = try! JSONDecoder().decode([UseRecordInfo].self, from: JSONSerialization.data(withJSONObject: dic))
                for useRecordInfo in useRecordInfos {
                    if let battery = useRecordInfo.battery {
                        batteryInt += battery
                    }
                    if let bottle = useRecordInfo.bottle {
                        bottleInt += bottle
                    }
                }
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.5) { [self] in
//                        let batteryprogress = Double(batteryInt)/1200
//                        let bottleprogress = Double(bottleInt)/1200
//                        progressGroup.ring1.progress = batteryprogress
//                        progressGroup.ring2.progress = bottleprogress
//                        if batteryprogress >= 1 && bottleprogress >= 1{
//                            isHiddenCongratulations(false)
//                        }
                    }
                }
            }
        }
    }
    
    @IBAction func goToRecycleLog(_ sender:UIButton) {
        if let navigationController = self.navigationController, let VC = UIStoryboard(name: "RecycleLog", bundle: Bundle.main).instantiateViewController(identifier: "RecycleLog") as? RecycleLogVC {
            pushVC(targetVC: VC, navigation: navigationController)
        }
    }
}

