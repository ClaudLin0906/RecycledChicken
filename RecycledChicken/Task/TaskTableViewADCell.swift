//
//  TaskTableViewADCell.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/16.
//

import UIKit
import Kingfisher

class TaskTableViewADCell: UITableViewCell {
    
    static let identifier = "TaskTableViewADCell"
    
    @IBOutlet weak var background:UIView!
    
    @IBOutlet weak var titleLabel:CustomLabel!
    
    @IBOutlet weak var descriptionLabel:CustomLabel!
    
    @IBOutlet weak var pointLabel:UILabel!
    
    @IBOutlet weak var iconImageView:UIImageView!
    
    var delegate:TaskTableViewCellFinishDelete?
    
    var taskInfo:TaskInfo?
    {
        willSet{
            if let newValue = newValue, let isFinish = newValue.isFinish, isFinish {
                DispatchQueue.main.async { [self] in
                    background.backgroundColor = #colorLiteral(red: 0.783845365, green: 0.4409029484, blue: 0.1943545341, alpha: 1)
                }
            }else{
                DispatchQueue.main.async { [self] in
                    background.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                }
            }
        }
    }
    
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
    
    private var iconImageUrl:URL?
    {
        willSet {
            if let newValue = newValue {
                DispatchQueue.main.async { [self] in
                    iconImageView.kf.setImage(with: newValue)
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
    
    func setCell(_ taskInfo:TaskInfo) {
        DispatchQueue(label: "com.geek-is-stupid.queue.configure-cell").async {
            guard let title = taskInfo.title, let description = taskInfo.description, let reward = taskInfo.reward, let rewardPoint = reward.amount, let createTime = taskInfo.createTime else { return }
            
            if let title = taskInfo.title {
                self.title = title
            }
            
            if let taskDescription = taskInfo.description {
                self.taskDescription = taskDescription
            }
            
            if let reward = taskInfo.reward, let amount = reward.amount {
                self.point = String(amount)
            }
            
            if let iconUrl = taskInfo.iconUrl, let url = URL(string: iconUrl) {
                self.iconImageUrl = url
            }
            
            self.taskInfo = taskInfo
        }
    }
    
    func finishAction() {
        delegate?.taskTableViewCellFinish(taskInfo)
    }

}
