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

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "聯絡客服與合作提案"
        setDefaultNavigationBackBtn()
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit(){
        setupIdentityListDropDown()
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
            let connectSuccessView = ConnectSuccessView(frame: view.frame)
            connectSuccessView.alpha = 0
            addViewFullScreen(v: connectSuccessView)
            UIView.animate(withDuration: 2, delay: 0) {
                connectSuccessView.alpha = 1
            } completion: { _ in
                UIView.animate(withDuration: 2, delay: 0) {
                    connectSuccessView.alpha = 0
                } completion: { _ in
                    connectSuccessView.removeFromSuperview()
                }
            }
        }
    }

}
