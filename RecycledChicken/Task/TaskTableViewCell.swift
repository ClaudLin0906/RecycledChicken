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
    
    var taskInfo:TaskInfo?
    {
        willSet{
            if let newValue = newValue {
                if let isFinish = newValue.isFinish, isFinish {
                    background.backgroundColor = #colorLiteral(red: 0.783845365, green: 0.4409029484, blue: 0.1943545341, alpha: 1)
                }else{
                    background.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
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
    
    
    func setCell(_ taskInfo:TaskInfo, battery:Int, bottle:Int, colorlessBottle:Int, can:Int, cup:Int) {
        guard let taskType = taskInfo.type, let title = taskInfo.title, let description = taskInfo.description, let reward = taskInfo.reward, let rewardPoint = reward.amount, let requiredAmount = taskInfo.requiredAmount else { return }
        self.taskInfo = taskInfo
        var molecular:Int = 0
        switch taskType {
        case .battery:
            molecular = battery
        case .bottle:
            molecular = bottle + colorlessBottle
        case .can:
            molecular = can
        case .cup:
            molecular = cup
        default:
            break
        }
        titleLabel.text = title
        descriptionLabel.text = description
        pointLabel.text = String(rewardPoint)
        taskProgressView.setPercent(molecular, denominator: requiredAmount)
        if molecular >= requiredAmount {
            finishAction()
            self.taskInfo?.isFinish = true
        }
    }
    
    func setCell(_ taskInfo:TaskInfo, _ finishTimes:[String]) {
        guard let taskType = taskInfo.type, let title = taskInfo.title, let description = taskInfo.description, let reward = taskInfo.reward, let rewardPoint = reward.amount, let requiredAmount = taskInfo.requiredAmount, let createTime = taskInfo.createTime else { return }
        self.taskInfo = taskInfo
        titleLabel.text = title
        descriptionLabel.text = description
        pointLabel.text = String(rewardPoint)
        for finishTime in finishTimes {
            if createTime == finishTime {
                self.taskInfo?.isFinish = true
                break
            }
        }
    }
    
    private func shareFinishAction() {
        guard let taskInfo = taskInfo, let createTime = taskInfo.createTime else { return }
        var finishTasks = UserDefaults.standard.array(forKey: UserDefaultKey.shared.finishTasks) as? [String]
        finishTasks?.append(createTime)
        UserDefaults().set(finishTasks, forKey: UserDefaultKey.shared.finishTasks)
        
    }
    
    func finishAction() {
        guard let taskInfo = taskInfo, let createTime = taskInfo.createTime else { return }
        let finishTaskInfo = FinishTaskInfo(createTime: createTime)
        let finishTaskInfoDic = try? finishTaskInfo.asDictionary()
        NetworkManager.shared.requestWithJSONBody(urlString: APIUrl.domainName + APIUrl.quest, parameters: finishTaskInfoDic, AuthorizationToken: CommonKey.shared.authToken) { (data, statusCode, errorMSG) in
            guard let data = data, statusCode == 200 else {
                return
            }
            let apiResult = try? JSONDecoder().decode(ApiResult.self, from: data)
            if let status = apiResult?.status {
                switch status {
                case .success:
                    self.taskInfo?.isFinish = true
                    switch taskInfo.type {
                    case .share:
                        self.shareFinishAction()
                    default:
                        break
                    }
                case .failure:
                    break
                }
            }
        }
    }
    

}
