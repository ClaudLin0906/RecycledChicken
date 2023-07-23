//
//  LogOutView.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/10.
//

import UIKit

class LogOutView: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var logOutBtn:UIButton!
    
    weak var superVC:UIViewController?
    deinit {
        print("\(String(describing: superVC)) is being deinitialized")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }
    
    private func customInit(){
        loadNibContent()
    }
    
    @IBAction func logOut(_ sender:UIButton){
        loginOutRemoveObject()
        DispatchQueue.main.async {
            self.removeFromSuperview()
            if let VC = UIStoryboard(name: "SignLogin", bundle: nil).instantiateViewController(withIdentifier: "SignLogin") as? SignLoginVC, let topVC = getTopController() {
                self.superVC?.navigationController?.popToRootViewController(animated: false)
                VC.modalPresentationStyle = .fullScreen
                topVC.present(VC, animated: true)
            }
        }
    }
    
    @IBAction func cancel(_ sender:UIButton){
        self.removeFromSuperview()
    }

}
