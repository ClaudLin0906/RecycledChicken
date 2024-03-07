//
//  TaskVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/11.
//

import UIKit

class TaskVC: CustomRootVC {
    
    @IBOutlet weak var taskTableView:UITableView!
    
    private var taskInfos:[TaskInfo] = []
    {
        willSet{
            print(newValue.count)
        }
    }
    
    private var taskStatuss:[TaskStatus] = []
    
    private var batteryInt = 0
    
    private var bottleInt = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit(){
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getTaskInfo()
    }
    
    private func updateInfo(){
        getTaskStatus()
        getRecycleCount()
    }
    
    private func sharedAction(taskInfo:TaskInfo, completion: @escaping (Bool, String?) -> Void){
//        let url = "https://apps.apple.com/app/id6449214570"
        let url = taskInfo.url
        let activityVC = UIActivityViewController(activityItems: [url!], applicationActivities: nil)
        activityVC.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in

            if error != nil {
                completion(false, error?.localizedDescription)
                return
            }
            if completed {
                completion(true, nil)
            }
        }
        self.present(activityVC, animated: true, completion: nil)
    }
    
    private func getTaskStatus() {
        NetworkManager.shared.getJSONBody(urlString: APIUrl.domainName + APIUrl.getQuestStatus, authorizationToken: CommonKey.shared.authToken) { (data, statusCode, errorMSG) in
            guard statusCode == 200 else {
                showAlert(VC: self, title: "發生錯誤", message: errorMSG, alertAction: nil)
                return
            }
            if let data = data, let dic = try! JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [Any] {
                self.taskStatuss = try! JSONDecoder().decode([TaskStatus].self, from: JSONSerialization.data(withJSONObject: dic))
                DispatchQueue.main.async {
                    self.taskTableView.reloadData()
                }
            }
        }
    }
    
    private func getTaskInfo() {
        NetworkManager.shared.getJSONBody(urlString: APIUrl.domainName + APIUrl.getQuestList, authorizationToken: CommonKey.shared.authToken) { (data, statusCode, errorMSG) in
            guard statusCode == 200 else {
                showAlert(VC: self, title: "發生錯誤", message: errorMSG, alertAction: nil)
                return
            }
            if let data = data, let dic = try! JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [Any] {
                self.taskInfos = try! JSONDecoder().decode([TaskInfo].self, from: JSONSerialization.data(withJSONObject: dic))
                self.taskInfos = self.taskInfos.filter {
                    if let startDate = dateFromString($0.startTime), let endDate = dateFromString($0.endTime) {
                        return isDateWithinInterval(date: Date(), start: startDate, end: endDate)
                    }
                    return false
                }
                self.updateInfo()
            }
        }
    }
    
    private func getRecycleCount(){
        bottleInt = 0
        batteryInt = 0
        let sevenDays = getSevenDaysArray(targetDate: Date())
        let startTime = sevenDays[0].0
        let endTime = sevenDays[6].0
        let urlStr = APIUrl.domainName + APIUrl.useRecord + "?startTime=\(startTime)T00:00:00.000+08:00&endTime=\(endTime)T23:59:59.999+08:00"
        NetworkManager.shared.getJSONBody(urlString: urlStr, authorizationToken: CommonKey.shared.authToken) { data, statusCode, errorMSG in
            if let data = data, let dic = try! JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [Any] {
                let useRecordInfos = try! JSONDecoder().decode([UseRecordInfo].self, from: JSONSerialization.data(withJSONObject: dic))
                for useRecordInfo in useRecordInfos {
                    if let battery = useRecordInfo.battery {
                        self.batteryInt += battery
                    }
                    if let bottle = useRecordInfo.bottle {
                        self.bottleInt += bottle
                    }
                }
                DispatchQueue.main.async {
                    self.taskTableView.reloadData()
                }
            }
        }
    }
    
    private func signAlert(){
        let alertAction = UIAlertAction(title: "註冊", style: .default) { _ in
            loginOutRemoveObject()
            goToSignVC()
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        showAlert(VC: self, title: "碳員招募中！一起探索泥滑島的秘密", message: nil, alertAction: alertAction, cancelAction: cancelAction)
    }

}

extension TaskVC:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        taskInfos.count
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        if row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as! TaskTableViewCell
            return cell
        }
        if row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewADCell.identifier, for: indexPath) as! TaskTableViewADCell
            return cell
        }
        if row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewTicketCell.identifier, for: indexPath) as! TaskTableViewTicketCell
            return cell
        }
        return UITableViewCell()
//        var info = taskInfos[row]
//        info.isFinish = false
//        for taskStatus in taskStatuss {
//            if taskStatus.createTime == info.createTime && taskStatus.type == info.type {
//                info.isFinish = true
//                break
//            }
//        }
//        let type = info.type
//        switch type {
//        case .AD:
//            let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewADCell.identifier, for: indexPath) as! TaskTableViewADCell
//            cell.taskInfo = info
//            cell.setCell()
//            return cell
//        case .share:
//            let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as! TaskTableViewCell
//            cell.taskInfo = info
//            cell.setCell()
//            return cell
//        case .battery:
//            let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as! TaskTableViewCell
//            cell.taskInfo = info
//            cell.setCell(batteryInt: batteryInt)
//            return cell
//        case .bottle:
//            let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as! TaskTableViewCell
//            cell.taskInfo = info
//            cell.setCell(bottleInt: bottleInt)
//            return cell
//        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard CurrentUserInfo.shared.isGuest == false else {
            signAlert()
            return
        }
        if let cell = tableView.cellForRow(at: indexPath) as? TaskTableViewCell {
            let type = cell.taskInfo?.type
            switch type {
            case .share:
                if let isFinish = cell.taskInfo?.isFinish, !isFinish, let taskInfo = cell.taskInfo {
                    sharedAction(taskInfo: taskInfo, completion: { result, errorMSG in
                        guard result else {
                            showAlert(VC: self, title: errorMSG, message: nil, alertAction: nil)
                            return
                        }
                        var newTaskInfo = taskInfo
                        newTaskInfo.isFinish = result
                        cell.taskInfo? = newTaskInfo
                        cell.finishAction()
                    })
                }
            default:
                break
            }
        }

        if let cell = tableView.cellForRow(at: indexPath) as? TaskTableViewADCell {
            if let isFinish = cell.taskInfo?.isFinish, !isFinish {
                let adView = ADView(frame: UIScreen.main.bounds, type: .isTask)
                adView.cell = cell
                adView.taskInfo = cell.taskInfo
                keyWindow?.addSubview(adView)
            }
        }
    }
    
}
