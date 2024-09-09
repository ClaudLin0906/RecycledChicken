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
    
    private var partnerImageUrl:URL?
    {
        willSet {
            if let newValue = newValue {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
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
    
    private func requiredAmountHandle(_ submitted:Int){
        guard let taskInfo = self.taskInfo else { return }
        if let type = taskInfo.type {
            switch type {
            case .share:
                var molecular = 0
                if taskInfo.isFinish {
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
            self.taskInfo = taskInfo
            
            if let type = taskInfo.type, type == .battery || type == .bottle || type == .cup || type == .can {
                if let startTime = taskInfo.startTime, let endTime = taskInfo.endTime, let formattedStartDate = convertDateFormat(inputDateString: startTime, inputFormat: "yyyy/MM/dd", outputFormat: "yyyy-MM-dd"), let formattedEndDate = convertDateFormat(inputDateString: endTime, inputFormat: "yyyy/MM/dd", outputFormat: "yyyy-MM-dd") {
                    getRecords(taskInfo.sites, formattedStartDate, formattedEndDate) { [weak self] statusCode, errorMSG, useRecordInfos, battery, bottle, colorledBottle, colorlessBottle, can, cup in
                        guard let self = self else { return }
                        switch type {
                        case .battery:
                            requiredAmountHandle(battery ?? 0)
                        case .bottle:
                            var bottleCount = 0
                            if let bottle = bottle {
                                bottleCount += bottle
                            }
                            if let colorledBottle = colorledBottle {
                                bottleCount += colorledBottle
                            }
                            if let colorlessBottle = colorlessBottle {
                                bottleCount += colorlessBottle
                            }
                            requiredAmountHandle(bottleCount)
                        case .can:
                            requiredAmountHandle(can ?? 0)
                        case .cup:
                            requiredAmountHandle(cup ?? 0)
                        default:
                            break
                        }
                    }
                }
            }
        }
    }
    
    func finishAction() {
        delegate?.taskTableViewCellFinish(taskInfo)
    }
    
    private func finishUIAction(_ info:TaskInfo) {
        if info.isFinish {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                background.backgroundColor = #colorLiteral(red: 0.783845365, green: 0.4409029484, blue: 0.1943545341, alpha: 1)
                titleLabel.textColor = .white
                descriptionLabel.textColor = .white
                if let reward = info.reward, let type = reward.type, type != .point {
                    getTicketView.isHidden = false
                    taskProgressView.isHidden = true
                }
            }
        }else{
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                background.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                titleLabel.textColor = .black
                descriptionLabel.textColor = .black
                getTicketView.isHidden = true
                taskProgressView.isHidden = false
            }
        }
    }

}
