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
        checkVersion()
        forcedConversionLanguage(self, .traditionalChinese)
    }
    
    private func showUpdateAppAlertView() {
        let updateAppAlertView = UpdateAppAlertView(frame: UIScreen.main.bounds)
        keyWindow?.addSubview(updateAppAlertView)
    }
    
    private func checkVersion() {
        // 使用舊的 API，因為這是外部 API，返回格式可能不同
        NetworkManager.shared.getJSONBody(urlString: APIUrl.checkAppleStoreVersion) { data, statusCode, errosMSG in
            guard let data = data, statusCode == 200 else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let results = json["results"] as? [[String: Any]] {
                if let appleStoreVersion = results[0]["version"] as? String, let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                    let compareResult = self.compareVersions(currentVersion, appleStoreVersion)
                    switch compareResult {
                    case .orderedAscending:
                        self.showUpdateAppAlertView()
                    default:
                        break
                    }
                }
            }
        }
    }
    
    private func compareVersions(_ currentVersion: String, _ appleStoreVersion: String) -> ComparisonResult {
        let components1 = currentVersion.split(separator: ".").compactMap { Int($0) }
        let components2 = appleStoreVersion.split(separator: ".").compactMap { Int($0) }
        
        for i in 0..<min(components1.count, components2.count) {
            if components1[i] < components2[i] {
                return .orderedAscending
            } else if components1[i] > components2[i] {
                return .orderedDescending
            }
        }
        
        if components1.count < components2.count {
            return .orderedAscending
        } else if components1.count > components2.count {
            return .orderedDescending
        } else {
            return .orderedSame
        }
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
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            LoginSuccess = true
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func guestBtnAction(_ sender: UIButton) {
        let loginInfo = AccountInfo(userPhoneNumber: GuestInfo.shared.guestAccount, userPassword: GuestInfo.shared.guestPassword)
        let loginInfoDic = try? loginInfo.asDictionary()
        NetworkManager.shared.post(url: APIUrl.domainName + APIUrl.login,
                                    parameters: loginInfoDic,
                                    authorizationToken: "",
                                    responseType: LoginResponse.self) { [weak self] result in
            switch result {
            case .success(let response):
                CommonKey.shared.authToken = ""
                CommonKey.shared.authToken = response.token
                self?.loginSuccess()
            case .failure:
                DispatchQueue.main.async {
                    showAlert(VC: self, title: "error".localized, message: nil)
                }
            }
        }
    }
}
