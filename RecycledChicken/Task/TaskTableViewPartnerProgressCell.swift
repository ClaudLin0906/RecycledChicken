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
    
    private func getSpecifiedLocation(completion: @escaping (Int) -> Void) {
        guard let taskInfo = taskInfo, let sites = taskInfo.sites, let type = taskInfo.type else {
            completion(0)
            return
        }
        let sevenDays = getSevenDaysArray(targetDate: Date())
        let startTime = sevenDays[0].0
        let endTime = sevenDays[6].0
        getRecords(sites, startTime, endTime) {statusCode, errorMSG, useRecordInfos, battery, bottle, colorledBottle, colorlessBottle, can, cup in
            guard let statusCode = statusCode, statusCode == 200 else {
                print("\(errorMSG ?? "error".localized)")
                completion(0)
                return
            }
            switch type {
            case .battery:
                completion(battery ?? 0)
            case .bottle:
                completion(bottle ?? 0)
            case .colorledBottle:
                completion(colorledBottle ?? 0)
            case .colorlessBottle:
                completion(colorlessBottle ?? 0)
            case .can:
                completion(can ?? 0)
            case .cup:
                completion(cup ?? 0)
            default:
                completion(0)
            }
        }
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
            
            if taskInfo.isSpecifiedLocation {
                self.getSpecifiedLocation { submittedCount in
                    self.requiredAmountHandle(submittedCount)
                }
            }
            
            if !taskInfo.isSpecifiedLocation {
                self.requiredAmountHandle(submitted)
            }
        }
    }
    
    
    
    func finishAction() {
        delegate?.taskTableViewCellFinish(taskInfo)
    }

}
