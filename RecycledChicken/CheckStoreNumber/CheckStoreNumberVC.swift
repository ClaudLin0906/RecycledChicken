//
//  CheckStoreNumberVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2025/8/14.
//

import UIKit
import Kingfisher
class CheckStoreNumberVC: CustomVC {
    
    var myTickertCouponsInfo:MyTickertCouponsInfo? = nil
    
    @IBOutlet weak var itemImageView:UIImageView!
    
    @IBOutlet weak var itemNameLabel:CustomLabel!
    
    @IBOutlet weak var serialNumberLabel:CustomLabel!
    
    @IBOutlet weak var drawTimeLabel:CustomLabel!
    
    @IBOutlet weak var itemInstructionTextView:UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "myWallet".localized
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit() {
        addValue()
    }
    
    private func addValue() {
        guard let myTickertCouponsInfo = myTickertCouponsInfo else { return }
        
        if let picture = myTickertCouponsInfo.picture, let imageURL = URL(string: picture) {
            itemImageView.kf.setImage(with: imageURL)
        }
        
        itemNameLabel.text = myTickertCouponsInfo.name
        
        if let code = myTickertCouponsInfo.code {
            serialNumberLabel.text = "使用序號\(code)"
        }
        
        if let expire = myTickertCouponsInfo.expire {
            drawTimeLabel.text = "使用期限至\(expire)"
        }
        
        if let instruction = myTickertCouponsInfo.instruction {
            itemInstructionTextView.text = instruction
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultNavigationBackBtn2()
    }
}
