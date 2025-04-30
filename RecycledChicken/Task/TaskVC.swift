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
    
    private var shareTaskInfos:[TaskInfo] = []
    
    private var advertiseTaskInfos:[TaskInfo] = []
    
    private var recycledTaskInfos:[TaskInfo] = []
    
    private var specifiedLocationTaskInfos:[TaskInfo] = []
    
    @UserDefault(UserDefaultKey.shared.finishTasks, defaultValue: []) var currentFinishTasks:[String]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit() {
        taskTableView.register(UINib(nibName: "TaskTableSectionView", bundle: nil), forHeaderFooterViewReuseIdentifier: "TaskTableSectionView")
        taskTableView.setSeparatorLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getTaskInfo(completion: { [weak self] in
            guard let self = self else { return }
            self.classification()
            self.reloadTableView()
        })
    }
    
    private func sharedAction(_ taskInfo:TaskInfo, completion: @escaping (Bool, String?) -> Void){
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
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            responseTaskInfos.forEach { taskInfo in
                var newTaskInfo = taskInfo
                self.currentFinishTasks.forEach { finishTask in
                    if let createTime = newTaskInfo.createTime, createTime == finishTask {
//                        newTaskInfo.isFinish = true
                    }
                }
                if let sites = newTaskInfo.sites, sites.count > 0 {
                    newTaskInfo.isSpecifiedLocation = true
                }
                self.taskInfos.append(newTaskInfo)
            }
            completion()
        }
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
    
    private func classification() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let share = self.taskInfos.filter { $0.type == .share }
            let advertise = self.taskInfos.filter { $0.type == .advertise }
            let specified = self.taskInfos.filter { $0.isSpecifiedLocation }
            let remaining = self.taskInfos.filter { task in
                task.type != .share && task.type != .advertise && !task.isSpecifiedLocation
            }
            self.shareTaskInfos.append(contentsOf: share)
            self.advertiseTaskInfos.append(contentsOf: advertise)
            self.specifiedLocationTaskInfos.append(contentsOf: specified)
            self.recycledTaskInfos.append(contentsOf: remaining)
        }
    }
    
    private func getTaskInfo(completion: @escaping () -> Void) {
        NetworkManager.shared.getJSONBody(urlString: APIUrl.domainName + APIUrl.quest, authorizationToken: CommonKey.shared.authToken) { [weak self] data, statusCode, errorMSG in
            guard let self = self else { return }
            DispatchQueue.main.async {
                guard let data = data, statusCode == 200 else {
                    showAlert(VC: self, title: "error".localized, message: errorMSG)
                    return
                }
                if let taskInfos = try? JSONDecoder().decode([TaskInfo].self, from: data) {
                    self.clearTableViewData()
                    self.addStatus(taskInfos) {
                        //                    self.filterTaskInfoDate {
                        completion()
                        //                    }
                    }
                }
            }
        }
    }
    
    private func clearTableViewData() {
        taskInfos.removeAll()
        shareTaskInfos.removeAll()
        advertiseTaskInfos.removeAll()
        recycledTaskInfos.removeAll()
        specifiedLocationTaskInfos.removeAll()
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
            self.taskInfos[index].isReceive = true
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
                var apiErrorMessage = "不知名的錯誤"
                if let data = data,let apiResult = try? JSONDecoder().decode(ApiResult.self, from: data), let message = apiResult.message {
                    apiErrorMessage = message
                }
                showAlert(VC: self, title: errorMSG ?? apiErrorMessage)
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
    
    private func handleRecycledItemCell(_ tableView:UITableView, _ info:TaskInfo, _ finishTasks:[String]) -> UITableViewCell {
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
    
    private func dequeueAndConfigureCell(for tableView: UITableView, info: TaskInfo, section: Int, finishTasks: [String]) -> UITableViewCell {
        if section == 2 || section == 3 {
            return handleRecycledItemCell(tableView, info, finishTasks)
        }

        let isPartnerTask = info.reward?.type != .point

        if section == 0 {
            if isPartnerTask {
                let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewPartnerCell.identifier) as! TaskTableViewPartnerCell
                cell.delegate = self
                cell.setCell(info)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier) as! TaskTableViewCell
                cell.delegate = self
                cell.setCell(info)
                return cell
            }
        }

        if section == 1 {
            if isPartnerTask {
                let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewPartnerCell.identifier) as! TaskTableViewPartnerCell
                cell.delegate = self
                cell.setCell(info)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewADCell.identifier) as! TaskTableViewADCell
                cell.delegate = self
                cell.setCell(info)
                return cell
            }
        }

        return UITableViewCell()
    }
    
    private func getSectionInfos(for section: Int) -> [TaskInfo] {
        
        var availableSections: [TaskInfo] = []
        switch section {
        case 0:
            availableSections.append(contentsOf: shareTaskInfos)
        case 1:
            availableSections.append(contentsOf: advertiseTaskInfos)
        case 2:
            availableSections.append(contentsOf: recycledTaskInfos)
        case 3:
            availableSections.append(contentsOf: specifiedLocationTaskInfos)
        default:
            break
        }
        return availableSections
    }
    
}

extension TaskVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // 根據實際的 section 資料來決定高度
        let sectionInfos = getSectionInfos(for: section)
        return sectionInfos.isEmpty ? 0 : UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionInfos = getSectionInfos(for: section)
        guard !sectionInfos.isEmpty else { return nil }
        
        let taskTableSectionView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TaskTableSectionView") as? TaskTableSectionView
        taskTableSectionView?.automaticallyUpdatesBackgroundConfiguration = false
        switch section {
        case 0:
            taskTableSectionView?.setTitleLabel("分享連結")
        case 1:
            taskTableSectionView?.setTitleLabel("廣告播放")
        case 2:
            taskTableSectionView?.setTitleLabel("全站投遞")
        case 3:
            taskTableSectionView?.setTitleLabel("特殊站點投遞")
        default:
            taskTableSectionView?.setTitleLabel("")
        }
        return taskTableSectionView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getSectionInfos(for: section).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let finishTasks = UserDefaults.standard.array(forKey: UserDefaultKey.shared.finishTasks) as? [String] ?? []
        let taskInfo = getSectionInfos(for: indexPath.section)[indexPath.row]
        return dequeueAndConfigureCell(for: tableView, info: taskInfo, section: indexPath.section, finishTasks: finishTasks)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard CurrentUserInfo.shared.isGuest == false else {
            signAlert()
            return
        }
        
        let taskInfo = getSectionInfos(for: indexPath.section)[indexPath.row]
        
        if let type = taskInfo.type {
            switch type {
            case .share:
                if !taskInfo.isFinish {
                    sharedAction(taskInfo) { result, errorMSG in
                        guard result else {
                            showAlert(VC: self, title: errorMSG, message: nil)
                            return
                        }
                        if let cell = tableView.cellForRow(at: indexPath) as? TaskTableViewPartnerCell {
                            cell.finishAction()
                            return
                        }
                        if let cell = tableView.cellForRow(at: indexPath) as? TaskTableViewCell {
                            cell.finishAction()
                            return
                        }
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
