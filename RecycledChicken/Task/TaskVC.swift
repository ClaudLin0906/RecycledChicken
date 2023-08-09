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
    
    private func sharedAction(completion: @escaping (Bool, String?) -> Void){
        let activityVC = UIActivityViewController(activityItems: ["https://apps.apple.com/app/id6449214570"], applicationActivities: nil)
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
                DispatchQueue.main.async {
                    self.taskTableView.reloadData()
                }
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
                self.taskInfos = self.taskInfos.filter{
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
        let startTime = getDates(i: 0, currentDate: Date()).0
        let endTime = getDates(i: 6, currentDate: Date()).0
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
        var info = taskInfos[row]
        info.isFinish = false
        for taskStatus in taskStatuss {
            if taskStatus.createTime == info.createTime && taskStatus.type == info.type {
                info.isFinish = true
            }
        }
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
            if batteryInt >= info.count {
                info.isFinish = true
            }
            cell.taskInfo = info
            cell.taskProgressView.setPercent(info.count, molecular: batteryInt)
            return cell
        case .bottle:
            let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as! TaskTableViewCell
            cell.title.text = "寶特瓶回收\(info.count)瓶"
            if bottleInt >= info.count {
                info.isFinish = true
            }
            cell.taskInfo = info
            cell.taskProgressView.setPercent(info.count, molecular: bottleInt)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        if let cell = tableView.cellForRow(at: indexPath) as? TaskTableViewCell {
            let type = cell.taskInfo?.type
            switch type {
            case .share:
                if let isFinish = cell.taskInfo?.isFinish, !isFinish {
                    sharedAction { result, errorMSG in
                        guard result else {
                            showAlert(VC: self, title: errorMSG, message: nil, alertAction: nil)
                            return
                        }
                        cell.taskInfo?.isFinish = result
                        cell.finishAction()
                        cell.taskProgressView.setPercent(1, molecular: 1)
                    }
                }
            default:
                break
            }
        }

        if let cell = tableView.cellForRow(at: indexPath) as? TaskTableViewADCell {
//            let adView = ADView(frame: UIScreen.main.bounds)
            let adView = ADView(frame: UIScreen.main.bounds, type: .isTask)
            adView.cell = cell
            adView.taskInfo = cell.taskInfo
            keyWindow?.addSubview(adView)
        }
        
    }
    
}
