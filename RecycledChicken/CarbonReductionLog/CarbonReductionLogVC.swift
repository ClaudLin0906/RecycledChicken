//
//  CarbonReductionLogVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/8.
//

import UIKit
import MKRingProgressView
class CarbonReductionLogVC: CustomVC {
        
    @IBOutlet weak var recycleBtn:UIButton!
    
    @IBOutlet weak var progressGroup:RingProgressGroupView!
    
    @IBOutlet weak var carbonReductionNumber:UILabel!
    
    @IBOutlet weak var petView:PetView!
    
    @IBOutlet weak var battView:BattView!
    
    let parties = ["PET", "BATT"]
    
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
        recycleBtn.layer.borderWidth = 1
        recycleBtn.layer.borderColor = #colorLiteral(red: 0.7647058964, green: 0.7647058964, blue: 0.7647058964, alpha: 1)
        
        progressGroup.ring1.accessibilityLabel = NSLocalizedString("Move", comment: "")
        progressGroup.ring2.accessibilityLabel = NSLocalizedString("Exercise", comment: "")
        progressGroup.congratulationsTitle.text = "Congratulations!"
        progressGroup.congratulationsContent.text = "恭喜你電池回收量\n超額完成!"
        isHiddenCongratulations(true)
//        "Congratulations!\n恭喜你電池回收量\n超額完成!"
        // Do any additional setup after loading the view.

    }
    
    private func isHiddenCongratulations(_ isHidden:Bool) {
        progressGroup.congratulationsContent.isHidden = isHidden
        progressGroup.congratulationsTitle.isHidden = isHidden
    }
    
    private func getRecycleLogData(){
        guard let dateLastYear = dateLastYearSameDay(), let startTime = dateFromStringISO8601(date: dateLastYear).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let endTime = dateFromStringISO8601(date: Date()).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let urlStr = APIUrl.domainName + APIUrl.useRecord + "?startTime=\(startTime.replacingOccurrences(of: "+", with: "%2B"))&endTime=\(endTime.replacingOccurrences(of: "+", with: "%2B"))"
        NetworkManager.shared.getJSONBody(urlString: urlStr, authorizationToken: CommonKey.shared.authToken) { (data, statusCode, errorMSG) in
            guard statusCode == 200 else {
                showAlert(VC: self, title: "發生錯誤", message: errorMSG, alertAction: nil)
                return
            }
            var batteryInt = 0
            var bottleInt = 0
            if let data = data, let dic = try! JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [Any] {
                var useRecordInfos = try! JSONDecoder().decode([UseRecordInfo].self, from: JSONSerialization.data(withJSONObject: dic))
                for useRecordInfo in useRecordInfos {
                    if let battery = useRecordInfo.battery {
                        batteryInt += battery
                    }
                    if let bottle = useRecordInfo.bottle {
                        bottleInt += bottle
                    }
                }
                DispatchQueue.main.async {
                    self.battView.battAmount.text = String(batteryInt)
                    self.petView.petAmount.text = String(bottleInt)
                    UIView.animate(withDuration: 0.5) { [self] in
                        let batteryprogress = Double(batteryInt)/1200
                        let bottleprogress = Double(bottleInt)/1200
                        progressGroup.ring1.progress = batteryprogress
                        progressGroup.ring2.progress = bottleprogress
                        if batteryprogress >= 1 && bottleprogress >= 1{
                            isHiddenCongratulations(false)
                        }
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

