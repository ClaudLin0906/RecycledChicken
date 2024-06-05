//
//  SignLoginVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/6.
//

import UIKit

class SignLoginVC: CustomLoginVC {
    
    @IBOutlet weak var signUpBtn:UIButton!
    
    @IBOutlet weak var loginBtn:UIButton!
    
    @IBOutlet weak var guestLabelWidth:NSLayoutConstraint!
    
    @IBOutlet weak var label:UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        showUpdateAppAlertView()
        checkVersion()
    }
    
    private func showUpdateAppAlertView() {
//        let colorFillTypeTwoView = ColorFillTypeTwoView(frame:  UIScreen.main.bounds)
        let updateAppAlertView = UpdateAppAlertView(frame: UIScreen.main.bounds)
        keyWindow?.addSubview(updateAppAlertView)
    }
    
    private func checkVersion() {
        
    }

    private func UIInit(){
        signUpBtn.layer.borderWidth = 1
        signUpBtn.layer.borderColor = #colorLiteral(red: 0.7647058964, green: 0.7647058964, blue: 0.7647058964, alpha: 1)
        let paraph = NSMutableParagraphStyle()
        paraph.lineSpacing = 10
        let attributes = [NSAttributedString.Key.font:label.font,NSAttributedString.Key.paragraphStyle: paraph]
        label.attributedText = NSAttributedString(string: label.text ?? "", attributes: attributes as [NSAttributedString.Key : Any])
        label.textAlignment = .center
        if getLanguage() == .english {
            guestLabelWidth.constant = 100
        }
    }
    
    @IBAction func LoginBtnAction(_ sender:UIButton) {
        self.dismiss(animated: false) {
            if let VC = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "Login") as? LoginVC, let topVC = getTopController() {
                VC.modalPresentationStyle = .fullScreen
                topVC.present(VC, animated: true)
            }
        }
    }
    
    @IBAction func SignUpBtnAction(_ sender:UIButton) {
        self.dismiss(animated: false) {
            goToSignVC()
        }
    }
    
    private func loginSuccess(){
        DispatchQueue.main.async { [self] in
            LoginSuccess = true
            dismiss(animated: true)
        }
    }
    
    @IBAction func guestBtnAction(_ sender:UIButton) {
        let loginInfo = AccountInfo(userPhoneNumber: GuestInfo.shared.guestAccount, userPassword: GuestInfo.shared.guestPassword)
        let loginInfoDic = try? loginInfo.asDictionary()
        NetworkManager.shared.requestWithJSONBody(urlString: APIUrl.domainName+APIUrl.login, parameters: loginInfoDic) { (data, statusCode, errorMSG) in
            guard statusCode == 200 else {
                showAlert(VC: self, title: "error".localized, message: nil)
                return
            }
            if let data = data {
                let json = NetworkManager.shared.dataToDictionary(data: data)
                if let token = json["token"] as? String {
                    CommonKey.shared.authToken = ""
                    CommonKey.shared.authToken = token
                    self.loginSuccess()
                }
            }
        }
    }
}
