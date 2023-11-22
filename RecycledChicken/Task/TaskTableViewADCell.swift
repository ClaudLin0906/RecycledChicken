//
//  TaskTableViewADCell.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/16.
//

import UIKit

class TaskTableViewADCell: UITableViewCell {
    
    static let identifier = "TaskTableViewADCell"
    
    @IBOutlet weak var title:UILabel!
    
    @IBOutlet weak var background:UIView!
    
    @IBOutlet weak var point:UILabel!
    
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
    
    func setCell(){
        guard let taskInfo = taskInfo else { return }
        title.text = taskInfo.description
        point.text = String(taskInfo.point)
    }
    
    func finishAction(){
        guard let taskInfo = taskInfo else { return }
        let finishTaskInfo = FinishTaskInfo(questCreateTime: taskInfo.createTime, questType: taskInfo.type.rawValue)
        let finishTaskInfoDic = try?  finishTaskInfo.asDictionary()
        NetworkManager.shared.requestWithJSONBody(urlString: APIUrl.domainName + APIUrl.quest, parameters: finishTaskInfoDic, AuthorizationToken: CommonKey.shared.authToken) { (data, statusCode, errorMSG) in
            guard statusCode == 200 else {
                return
            }
            print(statusCode!)
        }
    }

}
