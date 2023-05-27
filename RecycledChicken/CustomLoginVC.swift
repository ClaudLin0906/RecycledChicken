//
//  CustomLoginVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/27.
//

import UIKit

class CustomLoginVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let closeTap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard(_:)))
        view.addGestureRecognizer(closeTap)
    }
    
    @objc private func closeKeyboard(_ tap:UITapGestureRecognizer){
        view.endEditing(true)
    }

}
