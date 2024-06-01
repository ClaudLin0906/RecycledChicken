//
//  TaskTableViewTicketCell.swift
//  RecycledChicken
//
//  Created by Claud on 2024/3/7.
//

import UIKit

class TaskTableViewTicketCell: UITableViewCell {
    
    static let identifier = "TaskTableViewTicketCell"
    
    @IBOutlet weak var background:UIView!
    
    @IBOutlet weak var taskTypeLabel:UILabel!
    
    @IBOutlet weak var getTicketBtn:UIButton!
    
    @IBOutlet weak var getticketBtnWidth:NSLayoutConstraint!
    
    @IBOutlet weak var finishBtn:UIButton!
    
    @IBOutlet weak var titleLabel:UILabel!
    
    var taskInfo:TaskInfo?
    {
        willSet{
            if let newValue = newValue, let isFinish = newValue.isFinish, isFinish {
                finishUIInit()
            }else{
                noFinishUIInit()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        finishBtn.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        if getLanguage() == .english {
            getticketBtnWidth.constant = 150
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func pressBtn(_ sender:UIButton) {
//        if let taskInfo = taskInfo, let isFinish = taskInfo.isFinish, !isFinish {
            finishUIInit()
//        }
    }
    
    private func finishUIInit() {
        background.backgroundColor = #colorLiteral(red: 0.783845365, green: 0.4409029484, blue: 0.1943545341, alpha: 1)
        titleLabel.textColor = .white
        taskTypeLabel.textColor = .white
        finishBtn.isHidden = false
        getTicketBtn.isHidden = true
    }
    
    private func noFinishUIInit() {
        background.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        titleLabel.textColor = .black
        taskTypeLabel.textColor = #colorLiteral(red: 0.3901114166, green: 0.5547710657, blue: 0.4950822592, alpha: 1)
        finishBtn.isHidden = true
        getTicketBtn.isHidden = false
    }

}
