//
//  DeleteAccountAlertVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/7/19.
//

import UIKit

class DeleteAccountAlertVC: UIViewController {
    
    @IBOutlet weak var passwordTextField:UITextField!
    
    weak var superVC:UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        let closeTap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard(_:)))
        view.addGestureRecognizer(closeTap)
        // Do any additional setup after loading the view.
    }
    
    @objc private func closeKeyboard(_ tap:UITapGestureRecognizer){
        view.endEditing(true)
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
        let deleteDic = try? DeleteInfo(password: password).asDictionary()
        NetworkManager.shared.requestWithJSONBody(urlString: APIUrl.domainName+APIUrl.delete, parameters: deleteDic, AuthorizationToken: CommonKey.shared.authToken){ (data, statusCode, errorMSG) in
            guard statusCode == 200 else {
                showAlert(VC: self, title: "發生錯誤", message: errorMSG, alertAction: nil)
                return
            }
            loginOutRemoveObject()
            DispatchQueue.main.async {
                self.dismiss(animated: true) {
                    if let VC = UIStoryboard(name: "SignLogin", bundle: nil).instantiateViewController(withIdentifier: "SignLogin") as? SignLoginVC, let topVC = getTopController() {
                        self.superVC?.navigationController?.popToRootViewController(animated: false)
                        VC.modalPresentationStyle = .fullScreen
                        topVC.present(VC, animated: true)
                    }
                }
            }
        }
    }

}
