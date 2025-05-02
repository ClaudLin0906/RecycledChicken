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
    
    @IBOutlet weak var comfirmButton:CustomButton!
    
    @IBOutlet weak var receivePointFinishView:ReceivePointFinishView!
        
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
//                    if submitted >= requiredAmount {
//                        self.taskInfo?.isFinish = true
//                    }
                }
            }
        }
    }
    
    func setCell(_ taskInfo:TaskInfo) {
        if let title = taskInfo.title {
            self.title = title
        }
        
        if let taskDescription = taskInfo.description {
            self.taskDescription = taskDescription
        }
        
        if let iconUrl = taskInfo.iconUrl, let url = URL(string: iconUrl) {
            self.partnerImageUrl = url
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
            if let type = taskInfo.type, type == .battery || type == .bottle || type == .cup || type == .can {
                if let startTime = taskInfo.startTime, let endTime = taskInfo.endTime, let formattedStartDate = convertDateFormat(inputDateString: startTime, inputFormat: "yyyy/MM/dd", outputFormat: "yyyy-MM-dd"), let formattedEndDate = convertDateFormat(inputDateString: endTime, inputFormat: "yyyy/MM/dd", outputFormat: "yyyy-MM-dd") {
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
    }

    @IBAction func finishActionConfirm(_ btn:CustomButton) {
        delegate?.taskTableViewCellFinish(taskInfo)
    }
    
    private func finishUIAction(_ info:TaskInfo) {
        if info.isReceive {
            receiveFinishUIAction()
        } else if info.isFinish && !info.isReceive {
            finishNoReceiveUIAction()
        } else if !info.isFinish && !info.isReceive {
            noFinishNoReceiveUIAction()
        }
    }
    
    private func receiveFinishUIAction() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            background.backgroundColor = #colorLiteral(red: 0.7843137255, green: 0.4392156863, blue: 0.1960784314, alpha: 1)
            titleLabel.textColor = .white
            descriptionLabel.textColor = .white
            taskProgressView.isHidden = true
            if let taskInfo = self.taskInfo, let reward = taskInfo.reward, let type = reward.type {
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
            background.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            titleLabel.textColor = .black
            descriptionLabel.textColor = .black
            getTicketView.isHidden = true
            receivePointFinishView.isHidden = true
            taskProgressView.isHidden = showConfirmButton
            comfirmButton.isHidden = !showConfirmButton
        }
    }

}
