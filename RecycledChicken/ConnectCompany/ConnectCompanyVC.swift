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
    
    @IBOutlet weak var errorMessageLabel:UILabel!
    
    let identityListDropDown = DropDown()
    
    private var keyMoveSize:CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "contactPartnership".localized
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
            "user".localized,
            "collaboratingPartner".localized
        ]
        
        identityListDropDown.selectionAction = { [weak self] (index, item) in
            self?.identityLabel.text = item
        }
    }
    
    private func moveView(contentInsets:CGFloat){
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0) {
            self.view.bounds.origin.y = contentInsets
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            print(touch.location(in: contentView))
            print(touch.location(in: emailTextfield))
        }
    }
    
    private func sendEmailAction(content:String, email:String){
        let username = CurrentUserInfo.shared.currentProfileNewInfo?.userName ?? ""
        let identity = identityLabel.text ?? ""
        let sendEmailInfo = SendEmailInfo(recipient: identity, content: content, email: email, userName: username)
        let sendEmailDic = try? sendEmailInfo.asDictionary()
        NetworkManager.shared.requestWithJSONBody(urlString: APIUrl.domainName+APIUrl.sendEmail, parameters: sendEmailDic, AuthorizationToken: CommonKey.shared.authToken){ data, statusCode, errorMSG in
            guard statusCode == 200 else {
                showAlert(VC: self, title: "error".localized, message: errorMSG)
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
    
    func showErrorMessage(_ errorContent:String) {
        errorMessageLabel.isHidden = false
        errorMessageLabel.text = errorContent
    }
    
    @IBAction func mailSendSuccess(_ sender:UIButton) {
        var alertMsg = ""
        let email = emailTextfield.text
        let content = contentView.text
        
        if content == "" {
            showErrorMessage("contentCannotBeEmpty".localized)
            return
        }
        
        if email == "" {
            showErrorMessage("emailCannotBeEmpty".localized)
            return
        }
        
        if !validateEmail(text: email!) {
            showErrorMessage("incorrectEmailFormat".localized)
            return
        }
        
//        if content == "" {
//            alertMsg += "內容不能為空"
//        }
//
//        if email == "" {
//            alertMsg += "Email不能為空"
//        } else if !validateEmail(text: email!) {
//            alertMsg += "輸入正確聯絡信箱格式"
//        }
//        alertMsg = removeWhitespace(from: alertMsg)
//        guard alertMsg == "" else {
//            showAlert(VC: self, title: nil, message: alertMsg, alertAction: nil)
//            return
//        }
        sendEmailAction(content: content!, email: email!)
        
    }
    
    func showConnectSuccessView (){
        DispatchQueue.main.async {
            let connectSuccessView = ConnectSuccessView(frame: UIScreen.main.bounds)
            fadeInOutAni(showView: connectSuccessView, finishAction: nil)
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == keyMoveSize {
                var viewMaxY:CGFloat = 0
                if contentView.isFirstResponder {
                    if let contentViewFrameInWindow = contentView.superview?.convert(contentView.frame, to: nil) {
                        viewMaxY = contentViewFrameInWindow.maxY
                    }
                } else if emailTextfield.isFirstResponder {
                    if let emailTextfieldFrameInWindow = emailTextfield.superview?.convert(emailTextfield.frame, to: nil) {
                        viewMaxY = emailTextfieldFrameInWindow.maxY
                    }
                }
                let contentInsets = keyboardSize.height - (view.bounds.height - viewMaxY)
                moveView(contentInsets: contentInsets)
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.bounds.origin.y = 0
    }

}
