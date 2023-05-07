//
//  LogoAnimationVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/6.
//

import UIKit

class LogoAnimationVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showLoginVC()
    }
    

    private func showLoginVC(){
        if let rootVC = storyboard?.instantiateViewController(withIdentifier: "MainRootVC") as? MainRootVC {
            rootVC.modalPresentationStyle = .fullScreen
            present(rootVC, animated: false)
        }
    }
}
