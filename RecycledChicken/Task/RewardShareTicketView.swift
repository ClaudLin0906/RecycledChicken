//
//  RewardShareTicketView.swift
//  RecycledChicken
//
//  Created by ClaudLin on 2024/6/18.
//

import UIKit
import Kingfisher
class RewardShareTicketView: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var iconImageView:UIImageView!
    
    @IBOutlet weak var leftImageView:UIImageView!
        
    @IBOutlet weak var getTicketView:GetTicketView!
    
    @IBOutlet weak var playImageView:UIImageView!
    
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
    }
    
    func setInfo(_ iconURL:URL, leftURL:URL) {
        DispatchQueue.main.async {
            self.iconImageView.kf.setImage(with: iconURL)
            self.leftImageView.kf.setImage(with: leftURL)
        }
    }

}
