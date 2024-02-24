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
    
    @IBOutlet weak var contentView:UIView!
    
    var personMessageInfo:PersonMessageInfo?
    
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
        if let personMessageInfo = personMessageInfo {
            contentTextView?.text = personMessageInfo.message
            titleLabel.text = personMessageInfo.title
            if let date = dateFromString(personMessageInfo.createTime) {
                let createTime = getDates(i: 0, currentDate: date).0
                timeLabel.text = createTime
            }
        }
    }

    @IBAction func deleteAction(_ sender:UIButton) {
        let deleteAllMessageAlertView = DeleteAllMessageAlertView()
        deleteAllMessageAlertView.delegate = self
        deleteAllMessageAlertView.layer.cornerRadius = 5
        contentView.addSubview(deleteAllMessageAlertView)
        deleteAllMessageAlertView.translatesAutoresizingMaskIntoConstraints = false
        deleteAllMessageAlertView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        deleteAllMessageAlertView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        deleteAllMessageAlertView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        deleteAllMessageAlertView.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
    }

}

extension PersonMessageContentVC: DeleteAllMessageAlertViewDelegate {
    
    func deleteAllMessage() {
        
    }
    
}

