//
//  ConnectCompanyVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/10.
//

import UIKit
import DropDown
class ConnectCompanyVC: CustomVC {
        
    @IBOutlet weak var identityView:UIView!
    
    @IBOutlet weak var identityLabel:UILabel!
        
    @IBOutlet weak var contentView:UITextView!
    
    @IBOutlet weak var emailTextfield:UITextField!
    
    let identityListDropDown = DropDown()
    
    private var keyMoveSize:CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "聯絡客服與合作提案"
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit(){
        setupIdentityListDropDown()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultNavigationBackBtn()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        keyMoveSize = view.frame.origin.y
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupIdentityListDropDown() {
        identityListDropDown.anchorView = identityView
        identityListDropDown.bottomOffset = CGPoint(x: 0, y: identityView.bounds.height)
        
        identityListDropDown.dataSource =
        [
            "用戶",
            "合作廠商"
        ]
        
        identityListDropDown.selectionAction = { [weak self] (index, item) in
            self?.identityLabel.text = item
        }
    }
    
    private func sendEmailAction(content:String, email:String){
        let username = CurrentUserInfo.shared.currentProfileInfo?.userName ?? ""
        let identity = identityLabel.text ?? ""
        let sendEmailInfo = SendEmailInfo(recipient: identity, content: content, email: email, userName: username)
        let sendEmailDic = try? sendEmailInfo.asDictionary()
        NetworkManager.shared.requestWithJSONBody(urlString: APIUrl.domainName+APIUrl.sendEmail, parameters: sendEmailDic, AuthorizationToken: CommonKey.shared.authToken){ (data, statusCode, errorMSG) in
            guard statusCode == 200 else {
                showAlert(VC: self, title: "發生錯誤", message: errorMSG, alertAction: nil)
                return
            }
            if data != nil {
                self.showConnectSuccessView()
            }
        }
    }
    
    @IBAction func showIdentityListDropDown(_ tapGesture: UITapGestureRecognizer) {
        identityListDropDown.show()
    }
    
    @IBAction func mailSendSuccess(_ sender:UIButton) {
        var alertMsg = ""
        let email = emailTextfield.text
        let content = contentView.text
        
        if content == "" {
            alertMsg += "內容不能為空"
        }
        
        if email == "" {
            alertMsg += "Email不能為空"
        } else if !validateEmail(text: email!) {
            alertMsg += "Email格式不正確"
        }
        alertMsg = removeWhitespace(from: alertMsg)
        guard alertMsg == "" else {
            showAlert(VC: self, title: nil, message: alertMsg, alertAction: nil)
            return
        }
        sendEmailAction(content: content!, email: email!)
        
    }
    
    func showConnectSuccessView (){
        DispatchQueue.main.async { [self] in
            let connectSuccessView = ConnectSuccessView(frame: UIScreen.main.bounds)
            fadeInOutAni(showView: connectSuccessView, finishAction: nil)
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == keyMoveSize {
                self.view.frame.origin.y -= keyboardSize.height/1.8
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != keyMoveSize {
            self.view.frame.origin.y = keyMoveSize
        }
    }

}
