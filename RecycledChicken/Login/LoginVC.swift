//
//  LoginVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/6.
//

import UIKit
import M13Checkbox

class LoginVC: UIViewController {
    
    @IBOutlet weak var keepLoginCheckBox:M13Checkbox!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit(){
        keepLoginCheckBox.boxType = .square
        keepLoginCheckBox.stateChangeAnimation = .fill
    }

}
