//
//  TaskTableCell.swift
//  RecycledChicken
//
//  Created by ClaudLin on 2024/6/18.
//

import UIKit

class TaskTableCell: UITableViewCell {
    
    static let identifier = "TaskTableCell"
    
    @IBOutlet weak var titleLabel:CustomLabel!
    
    @IBOutlet weak var descriptionLabel:CustomLabel!
    
    @IBOutlet weak var background:UIView!
    
    @IBOutlet weak var rewardView:UIView!
    
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
    
    private var taskInfo:TaskInfo?
    {
        willSet{
            if let newValue = newValue {
                
            }
        }
    }
    
    var delegate:TaskTableViewCellFinishDelete?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    private func getRewardView() ->UIView {
//        guard let taskInfo = self.taskInfo, let type = taskInfo.type else { return UIView() }
//        switch type {
//        case .share:
//            <#code#>
//        case .advertise:
//            <#code#>
//        default:
//            if let reward = taskInfo.reward, let rewardType = reward.type, rewardType != .point {
//                let rewardShareTicketView = RewardShareTicketView()
//                return rewardShareTicketView
//            }
//        }
//        return UIView()
//    }
    
    func setCell(_ taskInfo:TaskInfo) {
        DispatchQueue(label: "com.geek-is-stupid.queue.configure-cell").async {
            if let title = taskInfo.title {
                self.title = title
            }
            
            if let taskDescription = taskInfo.description {
                self.taskDescription = taskDescription
            }
            self.taskInfo = taskInfo
        }
    }
    
    func finishAction() {
        delegate?.taskTableViewCellFinish(taskInfo)
    }

}
