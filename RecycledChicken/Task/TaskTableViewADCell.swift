//
//  TaskTableViewADCell.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/16.
//

import UIKit

class TaskTableViewADCell: UITableViewCell {
    
    static let identifier = "TaskTableViewADCell"
    
    @IBOutlet weak var background:UIView!
    
    @IBOutlet weak var titleLabel:CustomLabel!
    
    @IBOutlet weak var descriptionLabel:CustomLabel!
    
    @IBOutlet weak var pointLabel:UILabel!
    
    var taskInfo:TaskInfo?
    {
        willSet{
            if let newValue = newValue, let isFinish = newValue.isFinish, isFinish {
                background.backgroundColor = #colorLiteral(red: 0.783845365, green: 0.4409029484, blue: 0.1943545341, alpha: 1)
            }else{
                background.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
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
    
    func setCell(_ taskInfo:TaskInfo, _ finishTimes:[String]) {
        guard let title = taskInfo.title, let description = taskInfo.description, let reward = taskInfo.reward, let rewardPoint = reward.amount, let createTime = taskInfo.createTime else { return }
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
                    var finishTasks = UserDefaults.standard.array(forKey: UserDefaultKey.shared.finishTasks) as? [String]
                    finishTasks?.append(createTime)
                    UserDefaults().set(finishTasks, forKey: UserDefaultKey.shared.finishTasks)
                case .failure:
                    break
                }
            }
        }
    }

}
