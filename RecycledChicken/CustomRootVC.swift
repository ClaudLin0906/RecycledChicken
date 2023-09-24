//
//  CustomRootVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/6.
//

import UIKit

class CustomRootVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let closeTap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard(_:)))
        closeTap.cancelsTouchesInView = false
        view.addGestureRecognizer(closeTap)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    @objc private func closeKeyboard(_ tap:UITapGestureRecognizer){
        view.endEditing(true)
    }

}
