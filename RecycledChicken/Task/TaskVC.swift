//
//  TaskVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/11.
//

import UIKit

protocol TaskTableViewCellFinishDelete {
    func taskTableViewCellFinish(_ taskInfo:TaskInfo?)
}

class TaskVC: CustomRootVC {
    
    @IBOutlet weak var taskTableView:UITableView!
    
    private var taskInfos:[TaskInfo] = []
    
    @UserDefault(UserDefaultKey.shared.finishTasks, defaultValue: []) var currentFinishTasks:[String]

    override func viewDidLoad() {
        super.viewDidLoad()
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit() {
        taskTableView.setSeparatorLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getTaskInfo(completion: { [self] in
            reloadTableView()
        })
    }
    
    private func sharedAction(_ taskInfo:TaskInfo, completion: @escaping (Bool, String?) -> Void){
//        let url = "https://apps.apple.com/app/id6449214570"
        guard let url = taskInfo.url else { 
            completion(false, "url 有問題")
            return
        }
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
    
    private func addStatus(_ responseTaskInfos:[TaskInfo], completion: @escaping () -> Void) {
        responseTaskInfos.forEach { taskInfo in
            var newTaskInfo = taskInfo
            self.currentFinishTasks.forEach { finishTask in
                if let createTime = newTaskInfo.createTime, createTime == finishTask {
                    newTaskInfo.isFinish = true
                }
            }
            if let sites = newTaskInfo.sites, sites.count > 0 {
                newTaskInfo.isSpecifiedLocation = true
            }
            self.taskInfos.append(newTaskInfo)
        }
        completion()
    }
    
    private func filterTaskInfoDate(completion: @escaping () -> Void) {
        self.taskInfos = self.taskInfos.filter {
            if let startTime = $0.startTime, let startDate = dateFromString(startTime), let endTime = $0.endTime, let endDate = dateFromString(endTime) {
                return isDateWithinInterval(date: Date(), start: startDate, end: endDate)
            }
            return false
        }
        completion()
    }
    
    private func getTaskInfo(completion: @escaping () -> Void) {
        NetworkManager.shared.getJSONBody(urlString: APIUrl.domainName + APIUrl.quest, authorizationToken: CommonKey.shared.authToken) { data, statusCode, errorMSG in
            guard let data = data, statusCode == 200 else {
                showAlert(VC: self, title: "error".localized, message: errorMSG)
                return
            }
            if let taskInfos = try? JSONDecoder().decode([TaskInfo].self, from: data) {
                self.taskInfos.removeAll()
                self.addStatus(taskInfos) {
//                    self.filterTaskInfoDate {
                        completion()
//                    }
                }
            }
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
    
    private func successTaskAction(_ taskInfo:TaskInfo) {
        if let index = self.taskInfos.firstIndex(where: { $0.createTime == taskInfo.createTime}) {
            self.taskInfos[index].isFinish = true
        }
        if let createTime = taskInfo.createTime {
            currentFinishTasks.append(createTime)
        }
        reloadTableView()
    }
    
    private func reloadTableView() {
        DispatchQueue.main.async {
            self.taskTableView.reloadData()
        }
    }
    
    private func finishTaskAction(_ taskInfo:TaskInfo?) {
        guard let taskInfo = taskInfo, let createTime = taskInfo.createTime, let type = taskInfo.type else { return }
        let finishTaskInfo = FinishTaskInfo(createTime: createTime, type: type.rawValue)
        let finishTaskInfoDic = try? finishTaskInfo.asDictionary()
        NetworkManager.shared.requestWithJSONBody(urlString: APIUrl.domainName + APIUrl.questComplete, parameters: finishTaskInfoDic, AuthorizationToken: CommonKey.shared.authToken) { (data, statusCode, errorMSG) in
            guard let data = data, statusCode == 200 else {
                if statusCode == 304 {
                    self.successTaskAction(taskInfo)
                    return
                }
                showAlert(VC: self, title: errorMSG ?? "不知名的錯誤")
                return
            }
            let apiResult = try? JSONDecoder().decode(ApiResult.self, from: data)
            if let status = apiResult?.status {
                switch status {
                case .success:
                    self.successTaskAction(taskInfo)
                case .failure:
                    break
                }
            }
        }
    }
    
    private func handRecycledItemCell(_ tableView:UITableView, _ info:TaskInfo, _ finishTasks:[String]) -> UITableViewCell {
        if let reward = info.reward, let rewardType = reward.type, rewardType != .point {
            let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewPartnerProgressCell.identifier) as! TaskTableViewPartnerProgressCell
            cell.delegate = self
            cell.setCell(info)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier) as! TaskTableViewCell
        cell.delegate = self
        cell.setCell(info)
        return cell
    }

}

extension TaskVC:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let taskInfo = taskInfos[row]
        guard let type = taskInfo.type, let reward = taskInfo.reward, let rewardType = reward.type else {
            return UITableViewCell()
        }
        let finishTasks = UserDefaults.standard.array(forKey: UserDefaultKey.shared.finishTasks) as? [String] ?? []
        switch type {
        case .share:
            if rewardType != .point {
                let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewPartnerCell.identifier, for: indexPath) as! TaskTableViewPartnerCell
                cell.delegate = self
                cell.setCell(taskInfo)
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as! TaskTableViewCell
            cell.delegate = self
            cell.setCell(taskInfo)
            return cell
        case .advertise:
            if rewardType != .point {
                let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewPartnerCell.identifier, for: indexPath) as! TaskTableViewPartnerCell
                cell.delegate = self
                cell.setCell(taskInfo)
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewADCell.identifier, for: indexPath) as! TaskTableViewADCell
            cell.delegate = self
            cell.setCell(taskInfo)
            return cell
        default:
            let cell = handRecycledItemCell(tableView, taskInfo, finishTasks)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard CurrentUserInfo.shared.isGuest == false else {
            signAlert()
            return
        }
        let taskInfo = taskInfos[indexPath.row]
        if let type = taskInfo.type {
            switch type {
            case .share:
                if !taskInfo.isFinish {
                    sharedAction(taskInfo) { result, errorMSG in
                        guard result else { 
                            showAlert(VC: self, title: errorMSG, message: nil)
                            return
                        }
                    }
                    if let cell = tableView.cellForRow(at: indexPath) as? TaskTableViewCell {
                        cell.finishAction()
                    }
                }
            case .advertise:
                if !taskInfo.isFinish {
                    let adView = ADView(frame: UIScreen.main.bounds, type: .isTask)
                    
                    if let cell = tableView.cellForRow(at: indexPath) as? TaskTableViewADCell {
                        adView.taskTableViewADCell = cell
                    }
                    
                    if let cell = tableView.cellForRow(at: indexPath) as? TaskTableViewPartnerCell {
                        adView.taskTableViewPartnerCell = cell
                    }
                    adView.taskInfo = taskInfo
                    keyWindow?.addSubview(adView)

                }
            default:
                break
            }
        }
    }
}

extension TaskVC:TaskTableViewCellFinishDelete {
    func taskTableViewCellFinish(_ taskInfo: TaskInfo?) {
        finishTaskAction(taskInfo)
    }
}
