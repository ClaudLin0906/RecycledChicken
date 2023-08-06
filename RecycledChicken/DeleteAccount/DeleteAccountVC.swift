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
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit(){
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultNavigationBackBtn2()
    }
    
    @IBAction func deleteAction(_ sender:UIButton) {        
        if let VC = UIStoryboard(name: "DeleteAccountAlert", bundle: nil).instantiateViewController(withIdentifier: "DeleteAccountAlert") as? DeleteAccountAlertVC {
            VC.superVC = self
            VC.modalPresentationStyle = .fullScreen
            present(VC, animated: false)
        }
    }

}
