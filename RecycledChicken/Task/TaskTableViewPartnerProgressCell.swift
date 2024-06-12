//
//  TaskTableViewPartnerProgressCell.swift
//  RecycledChicken
//
//  Created by ClaudLin on 2024/6/6.
//

import UIKit
import Kingfisher
class TaskTableViewPartnerProgressCell: UITableViewCell {
    
    static let identifier = "TaskTableViewPartnerProgressCell"
    
    @IBOutlet weak var titleLabel:CustomLabel!
    
    @IBOutlet weak var descriptionLabel:CustomLabel!
    
    @IBOutlet weak var taskProgressView:TaskProgressView!
    
    @IBOutlet weak var partnerImageView:UIImageView!
    
    @IBOutlet weak var background:UIView!
    
    var delegate:TaskTableViewCellFinishDelete?
    
    var taskInfo:TaskInfo?
    {
        willSet{
            if let newValue = newValue, newValue.isFinish {
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
    
    private var partnerImageUrl:URL?
    {
        willSet {
            if let newValue = newValue {
                DispatchQueue.main.async { [self] in
                    partnerImageView.kf.setImage(with: newValue)
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
            
            if let iconUrl = taskInfo.iconUrl, let url = URL(string: iconUrl) {
                self.partnerImageUrl = url
            }
            self.taskInfo = taskInfo
            
            if let requiredAmount = taskInfo.requiredAmount {
                self.taskProgressView.setPercent(submitted, denominator: requiredAmount)
                if submitted >= requiredAmount {
                    self.taskInfo?.isFinish = true
                }
            }
        }
    }
    
    
    
    func finishAction() {
        delegate?.taskTableViewCellFinish(taskInfo)
    }

}
