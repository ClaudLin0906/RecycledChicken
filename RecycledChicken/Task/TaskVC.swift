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
    
//    private var taskStatus:[TaskStatus] = []
    
    private var batteryInt:Int?
    
    private var bottleInt:Int?
    
    private var colorledBottleInt:Int?
    
    private var colorlessBottleInt:Int?
    
    private var canInt:Int?
    
    private var cupInt:Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        getRecycleCount()
        getTaskInfo(completion: { [self] in
            DispatchQueue.main.async {
                self.taskTableView.reloadData()
            }
        })
    }
    
    private func updateInfo(){
//        getTaskStatus()
    }
    
    private func sharedAction(taskInfo:TaskInfo, completion: @escaping (Bool, String?) -> Void){
        let url = "https://apps.apple.com/app/id6449214570"
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
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
    
    private func getTaskInfo(completion: @escaping () -> Void) {
        NetworkManager.shared.getJSONBody(urlString: APIUrl.domainName + APIUrl.quest, authorizationToken: CommonKey.shared.authToken) { data, statusCode, errorMSG in
            guard let data = data, statusCode == 200 else {
                showAlert(VC: self, title: "error".localized, message: errorMSG)
                return
            }
            if let taskInfos = try? JSONDecoder().decode([TaskInfo].self, from: data) {
                self.taskInfos.removeAll()
                self.taskInfos.append(contentsOf: taskInfos)
//                self.taskInfos = self.taskInfos.filter {
//                    if let startTime = $0.startTime, let startDate = dateFromString(startTime), let endTime = $0.endTime, let endDate = dateFromString(endTime) {
//                        return isDateWithinInterval(date: Date(), start: startDate, end: endDate)
//                    }
//                    return false
//                }
                completion()
            }
        }
    }
    
    private func getRecycleCount() {
        let sevenDays = getSevenDaysArray(targetDate: Date())
        let startTime = sevenDays[0].0
        let endTime = sevenDays[6].0
        getRecords(self, startTime, endTime: endTime) { [self] useRecordInfos, battery, bottle, colorledBottleInt, colorlessBottle, can, cup in
            bottleInt = battery
            batteryInt = bottle
            colorlessBottleInt = colorledBottleInt
            colorlessBottleInt = colorlessBottle
            canInt = can
            cupInt = cup

        }
    }
    
    private func signAlert() {
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
        taskInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let taskInfo = taskInfos[row]
        guard let type = taskInfo.type else {
            return UITableViewCell()
        }
        let finishTasks = UserDefaults.standard.array(forKey: UserDefaultKey.shared.finishTasks) as? [String] ?? []
        switch type {
        case .share:
            let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as! TaskTableViewCell
            cell.setCell(taskInfo, finishTasks)
            return cell
        case .advertise:
            if let reward = taskInfo.reward, let type = reward.type, type == .ticket {
                let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewPartnerCell.identifier, for: indexPath) as! TaskTableViewPartnerCell
                cell.setCell(taskInfo, finishTasks)
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewADCell.identifier, for: indexPath) as! TaskTableViewADCell
            cell.setCell(taskInfo, finishTasks)
            return cell
        case .battery:
            if let reward = taskInfo.reward, let rewardType = reward.type, rewardType == .ticket {
                let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewPartnerProgressCell.identifier, for: indexPath) as! TaskTableViewPartnerProgressCell
                cell.setCell(taskInfo, finishTasks, submitted: batteryInt ?? 0)
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as! TaskTableViewCell
            cell.setCell(taskInfo, finishTasks, submitted: batteryInt ?? 0)
            return cell
        case .bottle:
            if let reward = taskInfo.reward, let rewardType = reward.type, rewardType == .ticket {
                let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewPartnerProgressCell.identifier, for: indexPath) as! TaskTableViewPartnerProgressCell
                cell.setCell(taskInfo, finishTasks, submitted: bottleInt ?? 0)
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as! TaskTableViewCell
            cell.setCell(taskInfo, finishTasks, submitted: bottleInt ?? 0)
            return cell
        case .can:
            if let reward = taskInfo.reward, let rewardType = reward.type, rewardType == .ticket {
                let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewPartnerProgressCell.identifier, for: indexPath) as! TaskTableViewPartnerProgressCell
                cell.setCell(taskInfo, finishTasks, submitted: canInt ?? 0)
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as! TaskTableViewCell
            cell.setCell(taskInfo, finishTasks, submitted: canInt ?? 0)
            return cell
        case .cup:
            if let reward = taskInfo.reward, let rewardType = reward.type, rewardType == .ticket {
                let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewPartnerProgressCell.identifier, for: indexPath) as! TaskTableViewPartnerProgressCell
                cell.setCell(taskInfo, finishTasks, submitted: cupInt ?? 0)
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as! TaskTableViewCell
            cell.setCell(taskInfo, finishTasks, submitted: cupInt ?? 0)
            return cell
        }
//        switch type {
//        case .share:
//            let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as! TaskTableViewCell
//            let finishTasks = UserDefaults.standard.array(forKey: UserDefaultKey.shared.finishTasks) as? [String] ?? []
//            cell.setCell(taskInfo, finishTasks)
//            return cell
//        case .advertise:
//            let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewADCell.identifier, for: indexPath) as! TaskTableViewADCell
//            let finishTasks = UserDefaults.standard.array(forKey: UserDefaultKey.shared.finishTasks) as? [String] ?? []
//            cell.taskInfo = taskInfo
//            return cell
//        default:
//            let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as! TaskTableViewCell
//            cell.setCell(taskInfo, battery: batteryInt, bottle: bottleInt, colorlessBottle: colorlessBottleInt, can: canInt, cup: cupInt)
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
                            showAlert(VC: self, title: errorMSG, message: nil)
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
