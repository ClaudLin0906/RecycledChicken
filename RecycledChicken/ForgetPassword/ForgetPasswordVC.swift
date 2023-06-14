//
//  ForgetPasswordVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/13.
//

import UIKit

class ForgetPasswordVC: CustomLoginVC {
    
    @IBOutlet weak var phoneTextfield:UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func sendSMS(_ sender:UIButton){
        var alertMsg = ""
        let phone = phoneTextfield.text
        
        if phone == "" {
            alertMsg += "電話不能為空"
        } else if !validateCellPhone(text: phone!) {
            alertMsg += "電話格式不對"
        }
        alertMsg = removeWhitespace(from: alertMsg)
        guard alertMsg == "" else {
            showAlert(VC: self, title: nil, message: alertMsg, alertAction: nil)
            return
        }
    }

}
