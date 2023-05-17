//
//  MainRootVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/6.
//

import UIKit

class MainRootVC: UIViewController {
    
    var isFirstOpen: Bool = true
    
    var backgroundView:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(removeBackground(_:)), name: .removeBackground, object: nil)
        backgroundView = UIView(frame: view.frame)
        backgroundView?.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.addSubview(backgroundView!)
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isFirstOpen {
            isFirstOpen = false
            showSignLoginVC()
        }
    }
    
    @objc private func removeBackground(_ notification:Notification){
        backgroundView?.removeFromSuperview()
        NotificationCenter.default.removeObserver(self, name: .removeBackground, object: nil)
    }
    
    private func showSignLoginVC(){
        if let VC = UIStoryboard(name: "SignLogin", bundle: nil).instantiateViewController(withIdentifier: "SignLogin") as? SignLoginVC {
            VC.modalPresentationStyle = .fullScreen
            present(VC, animated: false)
        }
    }

}
