//
//  RedeemedView.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2025/8/15.
//

import UIKit
import Kingfisher
class RedeemedView: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var completeImageView:UIImageView!
    
    @IBOutlet weak var completeStackView:UIStackView!
    
    @IBOutlet weak var completeItemNameLabel: CustomLabel!
    
    @IBOutlet weak var completeItemAlertView: UIView!
    
    @IBOutlet weak var completeDuringTimeLabel: CustomLabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }
    
    private func customInit(){
        loadNibContent()
        completeImageView.layer.cornerRadius = 10
        completeImageView.layer.masksToBounds = true
        completeItemAlertView.layer.borderWidth = 1
        completeItemAlertView.layer.borderColor = UIColor.white.cgColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        completeItemAlertView.layer.cornerRadius = completeItemAlertView.bounds.height / 2
        completeItemAlertView.layer.masksToBounds = true
    }
    
    func compeletedAction() {
        let color = #colorLiteral(red: 0.7294117647, green: 0.3607843137, blue: 0.1490196078, alpha: 1)
    }
    
    func setImage(_ imageUrl:String) {
        if let url = URL(string: imageUrl) {
            completeImageView.kf.setImage(with: url)
        }
    }
    
    func setCompleteItemNameLabel(_ itemName:String) {
        completeItemNameLabel.text = itemName
    }
        
    func setCompleteDuringTimeLabel(_ duringTime:String) {
        completeDuringTimeLabel.text = "兌換日期: \(duringTime)"
    }

}
