//
//  DeleteAccountAlertVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/7/19.
//

import UIKit

class DeleteAccountAlertVC: UIViewController {
    
    @IBOutlet weak var passwordTextField:UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func cancel(_ sender:UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func confirm(_ sender:UIButton) {
        var alertMsg = ""
        if let phone = passwordTextField.text {
            if phone == "" {
                alertMsg += "密碼不能為空"
            }else if phone.count < 8 || phone.count > 12 {
                alertMsg += "密碼字數不對"
            }
            
            alertMsg = removeWhitespace(from: alertMsg)
            
            guard alertMsg == "" else {
                showAlert(VC: self, title: nil, message: alertMsg, alertAction: nil)
                return
            }
            deleteAccountAction(phone)
        }
    }

    private func deleteAccountAction(_ password:String){
        self.dismiss(animated: true)
    }

}
