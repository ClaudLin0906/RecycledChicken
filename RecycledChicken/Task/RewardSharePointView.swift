//
//  RewardSharePointView.swift
//  RecycledChicken
//
//  Created by ClaudLin on 2024/6/18.
//

import UIKit

class RewardSharePointView: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var pointLabel:UILabel!
    
    @IBOutlet weak var pointView:UIView!
    
    @IBOutlet weak var iconImageView:UIImageView!
        
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

}
