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
            checkTaskStatus()
        }
    }
    
    private var taskStatuss:[TaskStatus] = []
    {
        willSet{
            checkTaskStatus()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        UIInit()
        getTaskInfo()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit(){
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getTaskStatus()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    private func checkTaskStatus(){
        guard taskInfos.count > 0, taskStatuss.count > 0 else { return }
        var filterTaskInfo:[TaskInfo] = []
        for taskInfo in taskInfos {
            var newTaskinfo = taskInfo
            for taskStatus in taskStatuss {
                if taskInfo.createTime == taskStatus.createTime && taskInfo.type == taskStatus.type {
                    newTaskinfo.isFinish = true
                }else{
                    newTaskinfo.isFinish = false
                }
            }
            newTaskinfo = taskInfo
            filterTaskInfo.append(newTaskinfo)
        }
        taskInfos = filterTaskInfo
    }
    
    private func sharedAction(completion: @escaping (Bool, String?) -> Void){
        let activityVC = UIActivityViewController(activityItems: ["test"], applicationActivities: nil)
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
    
    private func getTaskStatus(){
        NetworkManager.shared.getJSONBody(urlString: APIUrl.domainName + APIUrl.getQuestStatus, authorizationToken: CommonKey.shared.authToken) { (data, statusCode, errorMSG) in
            guard statusCode == 200 else {
                showAlert(VC: self, title: "發生錯誤", message: errorMSG, alertAction: nil)
                return
            }
            if let data = data, let dic = try! JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [Any] {
                self.taskStatuss = try! JSONDecoder().decode([TaskStatus].self, from: JSONSerialization.data(withJSONObject: dic))
            }
        }
    }
    
    private func getTaskInfo(){
        NetworkManager.shared.getJSONBody(urlString: APIUrl.domainName + APIUrl.getQuestList, authorizationToken: CommonKey.shared.authToken) { (data, statusCode, errorMSG) in
            guard statusCode == 200 else {
                showAlert(VC: self, title: "發生錯誤", message: errorMSG, alertAction: nil)
                return
            }
            if let data = data, let dic = try! JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [Any] {
                self.taskInfos = try! JSONDecoder().decode([TaskInfo].self, from: JSONSerialization.data(withJSONObject: dic))
//                self.taskInfos = self.taskInfos.filter{
//                    if let startDate = dateFromString($0.startTime), let endDate = dateFromString($0.endTime) {
//                        return isDateWithinInterval(date: Date(), start: startDate, end: endDate)
//                    }
//                    return false
//                }
                    
                DispatchQueue.main.async {
                    self.taskTableView.reloadData()
                }
            }
        }
    }

}

extension TaskVC:UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let info = taskInfos[row]
        let type = info.type
        switch type {
        case .AD:
            let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewADCell.identifier, for: indexPath) as! TaskTableViewADCell
            cell.title.text = "廣告點擊"
            cell.taskInfo = info
            return cell
        case .share:
            let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as! TaskTableViewCell
            cell.title.text = "社群分享"
            cell.taskProgressView.setPercent(1, molecular: 0)
            cell.taskInfo = info
            return cell
        case .battery:
            let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as! TaskTableViewCell
            cell.title.text = "電池回收\(info.count)個"
            cell.taskProgressView.setPercent(info.count, molecular: 0)
            cell.taskInfo = info
            return cell
        case .bottle:
            let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as! TaskTableViewCell
            cell.title.text = "寶特瓶回收\(info.count)瓶"
            cell.taskProgressView.setPercent(info.count, molecular: 0)
            cell.taskInfo = info
            return cell
        }
        
        
//        switch row {
//        case 0:
//            let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as! TaskTableViewCell
//            cell.title.text = "寶特瓶回收10瓶"
//            return cell
//        case 1:
//            let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as! TaskTableViewCell
//            cell.title.text = "電池回收10瓶"
//            return cell
//        case 2:
//            let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewADCell.identifier, for: indexPath) as! TaskTableViewADCell
//            cell.title.text = "廣告點擊"
//            return cell
//        case 3:
//            let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as! TaskTableViewCell
//            cell.title.text = "社群分享"
//            cell.taskProgressView.setPercent(1, molecular: 0)
//            return cell
//        default:
//            return UITableViewCell()
//        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        var info = taskInfos[row]
        if let cell = tableView.cellForRow(at: indexPath) as? TaskTableViewCell {
            let type = info.type
            switch type {
            case .share:
                sharedAction { result, errorMSG in
                    guard result else {
                        showAlert(VC: self, title: errorMSG, message: nil, alertAction: nil)
                        return
                    }
                    info.isFinish = result
                    cell.taskInfo = info
                }
            default:
                break
            }
        }

        if let cell = tableView.cellForRow(at: indexPath) as? TaskTableViewADCell {
            let adView = ADView(frame: UIScreen.main.bounds)
            adView.cell = cell
            adView.taskInfo = info
            keyWindow?.addSubview(adView)
        }
        
    }
    
}
