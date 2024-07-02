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
    
    @IBOutlet weak var pointView:UIView!
    
    @IBOutlet weak var getTicketView:GetTicketView!
    
    @IBOutlet weak var pointFinishView:UIView!
    
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
    
    private var taskInfo:TaskInfo?
    {
        willSet{
            if let newValue = newValue {
                finishUIAction(newValue)
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
    
    private func finishUIAction(_ info:TaskInfo) {
        if info.isFinish {
            DispatchQueue.main.async { [self] in
                background.backgroundColor = #colorLiteral(red: 0.783845365, green: 0.4409029484, blue: 0.1943545341, alpha: 1)
                titleLabel.textColor = .white
                descriptionLabel.textColor = .white
                pointLabel.textColor = .white
                taskProgressView.isHidden = true
                if let reward = info.reward, let type = reward.type {
                    if type != .point {
                        getTicketView.isHidden = false
                        pointView.isHidden = true
                    }
                    if type == .point {
                        pointFinishView.isHidden = false
                    }
                }
            }
        }else {
            DispatchQueue.main.async { [self] in
                background.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                titleLabel.textColor = .black
                descriptionLabel.textColor = .black
                pointLabel.textColor = .black
                getTicketView.isHidden = true
                taskProgressView.isHidden = false
                pointView.isHidden = false
                pointFinishView.isHidden = true
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
            
            if let reward = taskInfo.reward, let amount = reward.amount {
                self.point = String(amount)
            }
            
            self.taskInfo = taskInfo
            if let type = taskInfo.type, type == .battery || type == .bottle || type == .cup || type == .can, let startTime = taskInfo.startTime, let endTime = taskInfo.endTime, let formattedStartDate = convertDateFormat(inputDateString: startTime, inputFormat: "yyyy/MM/dd", outputFormat: "yyyy-MM-dd"), let formattedEndDate = convertDateFormat(inputDateString: endTime, inputFormat: "yyyy/MM/dd", outputFormat: "yyyy-MM-dd") {
                getRecords(taskInfo.sites, formattedStartDate, formattedEndDate) { [self] statusCode, errorMSG, useRecordInfos, battery, bottle, colorledBottle, colorlessBottle, can, cup in
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
                        finishAction()
                    }
                }
            }
        }
    }
    
    func finishAction() {
        delegate?.taskTableViewCellFinish(taskInfo)
    }
}
