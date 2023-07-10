//
//  HomeVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/6.
//

import UIKit

class HomeVC: CustomRootVC {
    
    @IBOutlet weak var barcodeView:BarCodeView!
    
    @IBOutlet weak var carbonReductionLogBtn:UIButton!
    
    @IBOutlet weak var currentDateLabel:UILabel!
    
    @IBOutlet weak var welcomeLabel:UILabel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        UIInit()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        barcodeView.code = CurrentUserInfo.shared.currentAccountInfo.userPhoneNumber
        if FirstTime && LoginSuccess {
            let welcomeView = WelcomeView(frame: UIScreen.main.bounds)
            keyWindow?.addSubview(welcomeView)
            FirstTime = false
            NotificationCenter.default.post(name: .removeBackground, object: nil)
        }
        updateCurrentDateInfo()
    }
    
    private func UIInit(){
        carbonReductionLogBtn.layer.borderWidth = 1
        carbonReductionLogBtn.layer.borderColor = #colorLiteral(red: 0.7647058964, green: 0.7647058964, blue: 0.7647058964, alpha: 1)
    }
    
    func updateCurrentDateInfo(){
        currentDateLabel.text = CustomCalenderModel.shared.selectedDate
        if let username = CurrentUserInfo.shared.currentProfileInfo?.userName{
            welcomeLabel.text = "Good morning, \(username)"
        }
        
    }
    
    @IBAction func goToCarbonReductionLog(_ sender:UIButton) {
        if let navigationController = self.navigationController, let VC = UIStoryboard(name: "CarbonReductionLog", bundle: Bundle.main).instantiateViewController(identifier: "CarbonReductionLog") as? CarbonReductionLogVC {
            pushVC(targetVC: VC, navigation: navigationController)
        }
    }
    
    @IBAction func goToProfile(_ sender:UIButton) {
        if let navigationController = self.navigationController, let VC = UIStoryboard(name: "Profile", bundle: Bundle.main).instantiateViewController(identifier: "Profile") as? ProfileVC {
            pushVC(targetVC: VC, navigation: navigationController)
        }
    }
    
    @IBAction func goToPersonMessage(_ sender:UIButton) {
        if let navigationController = self.navigationController, let VC = UIStoryboard(name: "PersonMessage", bundle: Bundle.main).instantiateViewController(identifier: "PersonMessage") as? PersonMessageVC {
            pushVC(targetVC: VC, navigation: navigationController)
        }
    }
    
    @IBAction func goToSettingMenu(_ sender:UIButton) {
        if let navigationController = self.navigationController, let VC = UIStoryboard(name: "SettingMenu", bundle: Bundle.main).instantiateViewController(identifier: "SettingMenu") as? SettingMenuVC {
            pushVC(targetVC: VC, navigation: navigationController)
        }
    }
}
