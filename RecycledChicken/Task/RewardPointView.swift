//
//  RewardPointView.swift
//  RecycledChicken
//
//  Created by ClaudLin on 2024/6/18.
//

import UIKit

class RewardPointView: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var pointLabel:UILabel!
    
    @IBOutlet weak var pointView:UIView!
    
    @IBOutlet weak var taskProgressView:TaskProgressView!
    
    @IBOutlet weak var getTicketView:GetTicketView!
    
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
