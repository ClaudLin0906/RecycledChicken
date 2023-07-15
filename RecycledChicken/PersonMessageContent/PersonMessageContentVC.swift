//
//  PersonMessageContentVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/9.
//

import UIKit

class PersonMessageContentVC: CustomVC {
    
    @IBOutlet weak var titleLabel:CustomLabel!
    
    @IBOutlet weak var timeLabel:CustomLabel!
    
    @IBOutlet weak var contentLabel:CustomLabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "個人訊息"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultNavigationBackBtn2()
    }


}
