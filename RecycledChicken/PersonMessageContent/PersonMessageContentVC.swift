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
        title = "personalNotifications".localized
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
            if let createTime = personMessageInfo.createTime, let date = dateFromString(createTime) {
                let createTime = getDates(i: 0, currentDate: date).0
                timeLabel.text = createTime
            }
        }
    }

    @IBAction func deleteAction(_ sender:UIButton) {
        let deleteMessageContentAlertView = DeleteMessageContentAlertView()
        deleteMessageContentAlertView.delegate = self
        deleteMessageContentAlertView.layer.cornerRadius = 5
        contentView.addSubview(deleteMessageContentAlertView)
        deleteMessageContentAlertView.translatesAutoresizingMaskIntoConstraints = false
        deleteMessageContentAlertView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        deleteMessageContentAlertView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        deleteMessageContentAlertView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        deleteMessageContentAlertView.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
    }

}

extension PersonMessageContentVC: DeleteMessageContentAlertViewDelegate {
    
    func deleteMessage() {
        guard let personMessageInfo = personMessageInfo else { return }
        let personMessageInfos = [personMessageInfo]
        var personMessageInfosDic:[[String:Any]] = []
        personMessageInfos.forEach { info in
            if let infoDic = try? info.asDictionary() {
                personMessageInfosDic.append(infoDic)
            }
        }
        NetworkManager.shared.requestWithJSONBody(urlString: APIUrl.domainName + APIUrl.messageDelete, parametersArray: personMessageInfosDic, AuthorizationToken: CommonKey.shared.authToken) { data, statusCode, errorMSG in
            guard statusCode == 200 else {
                showAlert(VC: self, title: "error".localized, message: errorMSG)
                return
            }
            if let data = data, let personMessageInfos = try? JSONDecoder().decode([PersonMessageInfo].self, from: data) {
                
            }
        }
    }
    
}

