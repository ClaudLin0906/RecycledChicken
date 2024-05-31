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
    
//    private var taskStatus:[TaskStatus] = []
    
    private var batteryInt = 0
    
    private var bottleInt = 0
    
    private var colorlessBottleInt = 0
    
    private var canInt = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getRecycleCount()
        getTaskInfo(completion: { [self] in
            updateInfo()
        })
    }
    
    private func updateInfo(){
//        getTaskStatus()
    }
    
//    private func sharedAction(taskInfo:TaskInfo, completion: @escaping (Bool, String?) -> Void){
//        let url = "https://apps.apple.com/app/id6449214570"
//        let url = taskInfo.url
//        let activityVC = UIActivityViewController(activityItems: [url!], applicationActivities: nil)
//        activityVC.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
//
//            if error != nil {
//                completion(false, error?.localizedDescription)
//                return
//            }
//            if completed {
//                completion(true, nil)
//            }
//        }
//        self.present(activityVC, animated: true, completion: nil)
//    }
    
    private func getTaskStatus(_ createTime:String, completion: @escaping () -> Void) {
        let taskStatusRequest = TaskStatusRequest(createTime: createTime)
        NetworkManager.shared.getJSONBody(urlString: APIUrl.domainName + APIUrl.questComplete, authorizationToken: CommonKey.shared.authToken) { (data, statusCode, errorMSG) in
            guard statusCode == 200 else {
                showAlert(VC: self, title: "error".localized, message: errorMSG)
                return
            }
//            if let data = data, let dic = try! JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [Any] {
//                self.taskStatuss = try! JSONDecoder().decode([TaskStatus].self, from: JSONSerialization.data(withJSONObject: dic))
//                DispatchQueue.main.async {
//                    self.taskTableView.reloadData()
//                }
//            }
            completion()
        }
    }
    
    private func getTaskInfo(completion: @escaping () -> Void) {
        NetworkManager.shared.getJSONBody(urlString: APIUrl.domainName + APIUrl.quest, authorizationToken: CommonKey.shared.authToken) { data, statusCode, errorMSG in
            guard let data = data, statusCode == 200 else {
                showAlert(VC: self, title: "error".localized, message: errorMSG)
                return
            }
            if let taskInfos = try? JSONDecoder().decode([TaskInfo].self, from: data) {
                self.taskInfos.removeAll()
                self.taskInfos.append(contentsOf: taskInfos)
                self.taskInfos = self.taskInfos.filter {
                    if let startTime = $0.activeTime?.startTime, let startDate = dateFromString(startTime), let endTime = $0.activeTime?.endTime, let endDate = dateFromString(endTime) {
                        return isDateWithinInterval(date: Date(), start: startDate, end: endDate)
                    }
                    return false
                }
                completion()
            }
        }
    }
    
    private func getRecycleCount() {
        bottleInt = 0
        batteryInt = 0
        colorlessBottleInt = 0
        canInt = 0
        let sevenDays = getSevenDaysArray(targetDate: Date())
        let startTime = sevenDays[0].0
        let endTime = sevenDays[6].0
        let urlStr = APIUrl.domainName + APIUrl.records + "?startTime=\(startTime)T00:00:00.000+08:00&endTime=\(endTime)T23:59:59.999+08:00"
        NetworkManager.shared.getJSONBody(urlString: urlStr, authorizationToken: CommonKey.shared.authToken) { [self] data, statusCode, errorMSG in
            guard let data = data, statusCode == 200 else {
                showAlert(VC: self, title: "error".localized, message: errorMSG)
                return
            }
            batteryInt = 0
            bottleInt = 0
            colorlessBottleInt = 0
            canInt = 0
            if let useRecordInfos = try? JSONDecoder().decode([UseRecordInfo].self, from: data) {
                useRecordInfos.forEach { useRecordInfo in
                    if let recycleDetails = useRecordInfo.recycleDetails {
                        if let battery = recycleDetails.battery {
                            batteryInt += battery
                        }
                        if let bottle = recycleDetails.bottle {
                            bottleInt += bottle
                        }
                        if let colorlessBottle = recycleDetails.colorlessBottle {
                            colorlessBottleInt += colorlessBottle
                        }
                        if let can = recycleDetails.can {
                            canInt += can
                        }
                    }
                }
            }
        }
    }
    
    private func signAlert(){
        let alertAction = UIAlertAction(title: "註冊", style: .default) { _ in
            loginOutRemoveObject()
            goToSignVC()
        }
        let cancelAction = UIAlertAction(title: "cancel".localized, style: .cancel)
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
                break
//                if let isFinish = cell.taskInfo?.isFinish, !isFinish, let taskInfo = cell.taskInfo {
//                    sharedAction(taskInfo: taskInfo, completion: { result, errorMSG in
//                        guard result else {
//                            showAlert(VC: self, title: errorMSG, message: nil)
//                            return
//                        }
//                        var newTaskInfo = taskInfo
//                        newTaskInfo.isFinish = result
//                        cell.taskInfo? = newTaskInfo
//                        cell.finishAction()
//                    })
//                }
            default:
                break
            }
        }

        if let cell = tableView.cellForRow(at: indexPath) as? TaskTableViewADCell {
//            if let isFinish = cell.taskInfo?.isFinish, !isFinish {
//                let adView = ADView(frame: UIScreen.main.bounds, type: .isTask)
//                adView.cell = cell
//                adView.taskInfo = cell.taskInfo
//                keyWindow?.addSubview(adView)
//            }
        }
    }
    
}
