//
//  ARVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/11.
//

import UIKit
//import LiGScannerKit
class ARVC: CustomRootVC {
    
    @IBOutlet weak var cameraImageView:UIImageView!
    
//    let scanner = LiGScanner.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit(){
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startScan()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopScan()
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @IBAction func goToProductDescription(_ sender:UIButton) {
        if let navigationController = self.navigationController, let VC = UIStoryboard(name: "ProductDescription", bundle: Bundle.main).instantiateViewController(identifier: "ProductDescription") as? ProductDescriptionVC {
            pushVC(targetVC: VC, navigation: navigationController)
        }
    }
    
    private func signAlert(){
        let alertAction = UIAlertAction(title: "註冊", style: .default) { _ in
            loginOutRemoveObject()
            goToSignVC()
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        showAlert(VC: self, title: "碳員招募中！一起探索泥滑島的秘密", message: nil, alertAction: alertAction, cancelAction: cancelAction)
    }
    
    private func startScan() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
//            self.scanner.stop()
//            self.scanner.start()
        }
    }
    
    private func stopScan() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
//            self.scanner.stop()
        }
        
    }
    
    @IBAction func btnAction(_ sender:UIButton) {
        guard CurrentUserInfo.shared.isGuest == false else {
            signAlert()
            return
        }
        if let navigationController = self.navigationController, let VC = UIStoryboard(name: "Scan", bundle: Bundle.main).instantiateViewController(identifier: "Scan") as? ScanViewController {
            pushVC(targetVC: VC, navigation: navigationController)
        }
    }
}
