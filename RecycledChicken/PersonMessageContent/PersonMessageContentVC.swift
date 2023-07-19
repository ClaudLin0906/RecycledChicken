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
    
    @IBOutlet weak var contentTextView:UITextView!
    
    var personMessageInfo:PersonMessageInfo?
    {
        willSet{
            if let newValue = newValue {
                contentTextView?.text = newValue.message
                if let date = dateFromString(newValue.createTime) {
                    let createTime = getDates(i: 0, currentDate: date).0
                    timeLabel.text = createTime
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "個人訊息"
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultNavigationBackBtn2()
    }
    
    private func UIInit(){
        
    }


}
