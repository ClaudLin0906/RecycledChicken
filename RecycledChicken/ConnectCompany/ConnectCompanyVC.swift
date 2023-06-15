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
    
    @IBAction func showIdentityListDropDown(_ tapGesture: UITapGestureRecognizer) {
        identityListDropDown.show()
    }
    
    @IBAction func mailSendSuccess(_ sender:UIButton) {
        showConnectSuccessView()
    }
    
    func showConnectSuccessView (){
        DispatchQueue.main.async { [self] in
            let connectSuccessView = ConnectSuccessView(frame: UIScreen.main.bounds)
            fadeInOutAni(showView: connectSuccessView)
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == keyMoveSize {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != keyMoveSize {
            self.view.frame.origin.y = keyMoveSize
        }
    }

}
