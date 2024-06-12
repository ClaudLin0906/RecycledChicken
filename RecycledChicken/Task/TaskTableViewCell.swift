//
//  TaskTableViewCell.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/13.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    static let identifier = "TaskTableViewCell"
    
    @IBOutlet weak var titleLabel:CustomLabel!
    
    @IBOutlet weak var descriptionLabel:CustomLabel!
    
    @IBOutlet weak var taskProgressView:TaskProgressView!
    
    @IBOutlet weak var background:UIView!
    
    @IBOutlet weak var pointLabel:UILabel!
    
    var delegate:TaskTableViewCellFinishDelete?
    
    private var title:String?
    {
        willSet {
            if let newValue = newValue {
                DispatchQueue.main.async { [self] in
                    titleLabel.text = newValue
                }
            }
        }
    }
    
    private var taskDescription:String?
    {
        willSet {
            if let newValue = newValue {
                DispatchQueue.main.async { [self] in
                    descriptionLabel.text = newValue
                }
            }
        }
    }
    
    private var point:String?
    {
        willSet {
            if let newValue = newValue {
                DispatchQueue.main.async { [self] in
                    pointLabel.text = newValue
                }
            }
        }
    }
    
    var taskInfo:TaskInfo?
    {
        willSet{
            if let newValue = newValue, let isFinish = newValue.isFinish, isFinish {
                DispatchQueue.main.async { [self] in
                    background.backgroundColor = #colorLiteral(red: 0.783845365, green: 0.4409029484, blue: 0.1943545341, alpha: 1)
                }
            } else {
                DispatchQueue.main.async { [self] in
                    background.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                }
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
    
    func setCell(_ taskInfo:TaskInfo, submitted:Int = 0) {
        DispatchQueue(label: "com.geek-is-stupid.queue.configure-cell").async {
            if let title = taskInfo.title {
                self.title = title
            }
            
            if let taskDescription = taskInfo.description {
                self.taskDescription = taskDescription
            }
            
            if let reward = taskInfo.reward, let amount = reward.amount {
                self.point = String(amount)
            }
            
            self.taskInfo = taskInfo
            
            if let type = taskInfo.type {
                switch type {
                case .share:
                    var molecular = 0
                    if let isFinish = taskInfo.isFinish, isFinish {
                        molecular = 1
                    }
                    self.taskProgressView.setPercent(molecular, denominator: 1)
                case .advertise:
                    break
                default:
                    if let requiredAmount = taskInfo.requiredAmount {
                        self.taskProgressView.setPercent(submitted, denominator: requiredAmount)
                        if submitted >= requiredAmount {
                            self.taskInfo?.isFinish = true
                        }
                    }
                }
            }
        }

    }
    
    func finishAction() {
        delegate?.taskTableViewCellFinish(taskInfo)
    }
}
