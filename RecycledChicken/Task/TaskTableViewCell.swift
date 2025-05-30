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
    
    @IBOutlet weak var labelStackView:UIStackView!
    
    @IBOutlet weak var taskProgressView:TaskProgressView!
    
    @IBOutlet weak var background:UIView!
    
    @IBOutlet weak var pointLabel:UILabel!
    
    @IBOutlet weak var pointView:UIView!
    
    @IBOutlet weak var getTicketView:GetTicketView!
    
    @IBOutlet weak var receivePointFinishView:ReceivePointFinishView!
    
    @IBOutlet weak var pointFinishView:UIView!
    
    @IBOutlet weak var comfirmButton:CustomButton!
        
    var delegate:TaskTableViewCellFinishDelete?
    
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
    
    private func finishUIAction(_ taskInfo:TaskInfo) {
        if taskInfo.isReceive {
            receiveFinishUIAction()
        } else if taskInfo.isFinish && !taskInfo.isReceive {
            finishNoReceiveUIAction()
        } else if !taskInfo.isFinish && !taskInfo.isReceive {
            noFinishNoReceiveUIAction()
        }
    }
    
    private func receiveFinishUIAction() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            labelStackViewUIInit()
            if let titleLabel = titleLabel {
                titleLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
            background.backgroundColor = #colorLiteral(red: 0.7294117647, green: 0.3607843137, blue: 0.1490196078, alpha: 1)
            descriptionLabel.textColor = .white
            pointLabel.textColor = .white
            comfirmButton.isHidden = true
            taskProgressView.isHidden = true
            if let taskInfo = self.taskInfo, let reward = taskInfo.reward, let type = reward.type {
                pointFinishView.isHidden = true
                if type != .point {
                    getTicketView.isHidden = false
                    receivePointFinishView.isHidden = true
                }
                if type == .point {
                    getTicketView.isHidden = true
                    receivePointFinishView.isHidden = false
                }
            }
        }
    }
    
    private func finishNoReceiveUIAction() {
        updateNoReceiveUI(showConfirmButton: true)
    }

    private func noFinishNoReceiveUIAction() {
        updateNoReceiveUI(showConfirmButton: false)
    }
    
    private func updateNoReceiveUI(showConfirmButton: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if let titleLabel = titleLabel {
                titleLabel.textColor = #colorLiteral(red: 0.3215686275, green: 0.4862745098, blue: 0.4196078431, alpha: 1)
            }
            labelStackViewUIInit()
            background.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            descriptionLabel.textColor = .black
            pointLabel.textColor = .black
            getTicketView.isHidden = true
            receivePointFinishView.isHidden = true
            taskProgressView.isHidden = showConfirmButton
            pointView.isHidden = false
            pointFinishView.isHidden = true
            comfirmButton.isHidden = !showConfirmButton
        }
    }
    
    private func labelStackViewUIInit() {
        if let taskInfo = taskInfo {
            titleLabel.isHidden = !taskInfo.isSpecifiedLocation
            if !taskInfo.isSpecifiedLocation {
                self.labelStackView.spacing = 0
            } else {
                self.labelStackView.spacing = 8
            }
        }
    }
    
    func setCell(_ taskInfo:TaskInfo) {
        if taskInfo.isSpecifiedLocation {
            if let title = taskInfo.title {
                self.title = title
            }
        }
        
        if let taskDescription = taskInfo.description {
            self.taskDescription = taskDescription
        }
        
        if let reward = taskInfo.reward, let amount = reward.amount {
            self.point = String(amount)
        }
        
        if let reward = taskInfo.reward, let rewardType = reward.type {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if rewardType == .point {
                    self.comfirmButton.setTitle("點擊領取", for: .normal)
                } else {
                    self.comfirmButton.setTitle("領取票卷", for: .normal)
                }
            }
        }
        
        self.taskInfo = taskInfo
        
        if !taskInfo.isFinish {
            if let type = taskInfo.type, type == .battery || type == .bottle || type == .cup || type == .can, let startTime = taskInfo.startTime, let endTime = taskInfo.endTime, let formattedStartDate = convertDateFormat(inputDateString: startTime, inputFormat: "yyyy/MM/dd", outputFormat: "yyyy-MM-dd"), let formattedEndDate = convertDateFormat(inputDateString: endTime, inputFormat: "yyyy/MM/dd", outputFormat: "yyyy-MM-dd") {
                getRecords(taskInfo.sites, formattedStartDate, formattedEndDate) { [weak self] statusCode, errorMSG, useRecordInfos, battery, bottle, colorledBottle, colorlessBottle, can, cup in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        switch type {
                        case .battery:
                            self.requiredAmountHandle(battery ?? 0)
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
                            self.requiredAmountHandle(bottleCount)
                        case .can:
                            self.requiredAmountHandle(can ?? 0)
                        case .cup:
                            self.requiredAmountHandle(cup ?? 0)
                        default:
                            break
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func finishActionConfirm(_ btn:CustomButton) {
        finishAction()
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
    
    func finishAction() {
        delegate?.taskTableViewCellFinish(taskInfo)
    }
}
