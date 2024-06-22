//
//  TaskTableViewPartnerCell.swift
//  RecycledChicken
//
//  Created by ClaudLin on 2024/6/6.
//

import UIKit
import Kingfisher
class TaskTableViewPartnerCell: UITableViewCell {
    
    static let identifier = "TaskTableViewPartnerCell"
    
    @IBOutlet weak var background:UIView!
    
    @IBOutlet weak var titleLabel:CustomLabel!
    
    @IBOutlet weak var descriptionLabel:CustomLabel!
    
    @IBOutlet weak var partnerImageView:UIImageView!
    
    @IBOutlet weak var leftImageView:UIImageView!
    
    @IBOutlet weak var playImageView:UIImageView!
        
    @IBOutlet weak var getTicketView:GetTicketView!
    
    var delegate:TaskTableViewCellFinishDelete?
            
    private var taskInfo:TaskInfo?
    {
        willSet{
            if let newValue = newValue {
                finishUIAction(newValue)
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
    
    private var leftImageUrl:URL?
    {
        willSet {
            if let newValue = newValue {
                DispatchQueue.main.async { [self] in
                    leftImageView.kf.setImage(with: newValue)
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
            if let title = taskInfo.title {
                self.title = title
            }
            
            if let taskDescription = taskInfo.description {
                self.taskDescription = taskDescription
            }
            
            if let iconUrl = taskInfo.iconUrl, let url = URL(string: iconUrl) {
                self.partnerImageUrl = url
            }
            
            if let leftIcon = taskInfo.leftIcon, let url = URL(string: leftIcon) {
                self.leftImageUrl = url
            }
            self.taskInfo = taskInfo
        }
    }
    
    func finishAction() {
        delegate?.taskTableViewCellFinish(taskInfo)
    }
    
    private func finishUIAction(_ info:TaskInfo) {
        if info.isFinish {
            DispatchQueue.main.async { [self] in
                background.backgroundColor = #colorLiteral(red: 0.783845365, green: 0.4409029484, blue: 0.1943545341, alpha: 1)
                if let reward = info.reward, let type = reward.type, type != .point {
                    getTicketView.isHidden = false
                    playImageView.isHidden = true
                    leftImageView.isHidden = true
                    partnerImageView.isHidden = true
                }
            }
        }else {
            DispatchQueue.main.async { [self] in
                background.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                getTicketView.isHidden = true
                playImageView.isHidden = false
                leftImageView.isHidden = false
                partnerImageView.isHidden = false
            }
        }
    }

}
