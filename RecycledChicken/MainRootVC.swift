//
//  MainRootVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/6.
//

import UIKit

class MainRootVC: UIViewController {
    
    var isFirstOpen: Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isFirstOpen {
            isFirstOpen = false
            showSignLoginVC()
        }
    }
    
    private func showSignLoginVC(){
        if let VC = UIStoryboard(name: "SignLogin", bundle: nil).instantiateViewController(withIdentifier: "SignLogin") as? SignLoginVC {
            VC.modalPresentationStyle = .fullScreen
            present(VC, animated: false)
        }
    }

}
