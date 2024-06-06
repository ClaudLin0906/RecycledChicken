//
//  TaskTableViewPartnerProgressCell.swift
//  RecycledChicken
//
//  Created by ClaudLin on 2024/6/6.
//

import UIKit

class TaskTableViewPartnerProgressCell: UITableViewCell {
    
    static let identifier = "TaskTableViewPartnerProgressCell"
    
    @IBOutlet weak var titleLabel:CustomLabel!
    
    @IBOutlet weak var descriptionLabel:CustomLabel!
    
    @IBOutlet weak var taskProgressView:TaskProgressView!
    
    @IBOutlet weak var partnerImageView:UIImageView!
    
    @IBOutlet weak var background:UIView!
    
    var taskInfo:TaskInfo?
    {
        willSet{
            if let newValue = newValue, let isFinish = newValue.isFinish, isFinish {
                background.backgroundColor = #colorLiteral(red: 0.783845365, green: 0.4409029484, blue: 0.1943545341, alpha: 1)
            }else{
                background.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(_ taskInfo:TaskInfo, _ finishTimes:[String]) {
        
    }

}
