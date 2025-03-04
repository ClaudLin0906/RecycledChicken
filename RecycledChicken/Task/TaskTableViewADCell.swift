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
    
    @IBOutlet weak var playImageView:UIImageView!
    
    @IBOutlet weak var pointView:UIView!
    
    @IBOutlet weak var getTicketView:GetTicketView!
    
    @IBOutlet weak var pointFinishView:UIView!
    
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
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    titleLabel.text = newValue
                }
            }
        }
    }
    
    private var taskDescription:String?
    {
        willSet {
            if let newValue = newValue {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    descriptionLabel.text = newValue
                }
            }
        }
    }
    
    private var point:String?
    {
        willSet {
            if let newValue = newValue {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    pointLabel.text = newValue
                }
            }
        }
    }
    
    private var iconImageUrl:URL?
    {
        willSet {
            if let newValue = newValue {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
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
    
    private func finishUIAction(_ info:TaskInfo) {
        if info.isFinish {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                background.backgroundColor = #colorLiteral(red: 0.783845365, green: 0.4409029484, blue: 0.1943545341, alpha: 1)
                titleLabel.textColor = .white
                descriptionLabel.textColor = .white
                pointLabel.textColor = .white
                iconImageView.isHidden = true
                if let reward = info.reward, let type = reward.type {
                    if type != .point {
                        getTicketView.isHidden = false
                        playImageView.isHidden = true
                        pointView.isHidden = true
                    }
                    if type == .point {
                        pointFinishView.isHidden = false
                    }
                }
            }
        }else {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                background.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                titleLabel.textColor = .black
                descriptionLabel.textColor = .black
                pointLabel.textColor = .black
                getTicketView.isHidden = true
                playImageView.isHidden = false
                iconImageView.isHidden = false
                pointView.isHidden = false
                pointFinishView.isHidden = true
            }
        }
    }
    
    func finishAction() {
        delegate?.taskTableViewCellFinish(taskInfo)
    }

}
