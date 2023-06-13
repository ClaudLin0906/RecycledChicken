//
//  SignVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/7.
//

import UIKit

class SignVC: CustomLoginVC {

    @IBOutlet weak var userNameTextfield:UITextField!
    
    @IBOutlet weak var phoneTextfield:UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    private func goToVerificationCode(){
        self.dismiss(animated: true) {
            if let VC = UIStoryboard(name: "VerificationCode", bundle: nil).instantiateViewController(withIdentifier: "VerificationCode") as? VerificationCodeVC, let topVC = getTopController() {
                VC.modalPresentationStyle = .fullScreen
                topVC.present(VC, animated: true)
            }
        }
    }
    
    @IBAction func sendVerificationCode(_ sender:UIButton) {
        var alertMsg = ""
        let username = userNameTextfield.text
        let phone = phoneTextfield.text
        if username == "" {
            alertMsg += "名稱不能為空"
        }
        
        if phone == "" {
            alertMsg += "電話不能為空"
        } else if !validateCellPhone(text: phone!) {
            alertMsg += "電話格式不對"
        }
        
        guard alertMsg == "" else {
            return
        }
    }

}
