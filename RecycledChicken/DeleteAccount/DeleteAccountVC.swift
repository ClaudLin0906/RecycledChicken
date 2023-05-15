//
//  DeleteAccountVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/10.
//

import UIKit

class DeleteAccountVC: CustomVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "刪除帳號"
        setDefaultNavigationBackBtn2()
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit(){
        
    }
    
    @IBAction func deleteAction(_ sender:UIButton) {
        let deleteAccountAlertView = DeleteAccountAlertView(frame: view.frame)
        keyWindow?.addSubview(deleteAccountAlertView)
    }

}
