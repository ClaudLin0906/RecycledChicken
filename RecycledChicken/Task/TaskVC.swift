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

    override func viewDidLoad() {
        super.viewDidLoad()
        UIInit()
        getTaskInfo()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit(){
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func getTaskInfo(){
        NetworkManager.shared.getJSONBody(urlString: APIUrl.domainName + APIUrl.getQuestList, authorizationToken: CommonKey.shared.authToken) { (data, statusCode, errorMSG) in
            guard statusCode == 200 else {
                showAlert(VC: self, title: "發生錯誤", message: errorMSG, alertAction: nil)
                return
            }
            if let data = data {
                if let dic = try! JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [Any]{
                    let taskInfos = try! JSONDecoder().decode([TaskInfo].self, from: JSONSerialization.data(withJSONObject: dic))
                    self.taskInfos = taskInfos.filter{
                        if let startDate = dateFromString($0.startTime), let endDate = dateFromString($0.endTime) {
                            return isDateWithinInterval(date: Date(), start: startDate, end: endDate)
                        }
                        return false
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
        let info = taskInfos[row]
        let type = info.type
        switch type {
        case .AD:
            let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewADCell.identifier, for: indexPath) as! TaskTableViewADCell
            cell.title.text = "廣告點擊"
            return cell
        case .share:
            let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as! TaskTableViewCell
            cell.title.text = "社群分享"
            cell.taskProgressView.setPercent(1, molecular: 0)
            return cell
        case .battery:
            let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as! TaskTableViewCell
            cell.title.text = "電池回收\(info.count)個"
            cell.taskProgressView.setPercent(info.count, molecular: 0)
            return cell
        case .bottle:
            let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as! TaskTableViewCell
            cell.title.text = "寶特瓶回收\(info.count)瓶"
            cell.taskProgressView.setPercent(info.count, molecular: 0)
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
        let info = taskInfos[row]
        let type = info.type
        
        if let cell = tableView.cellForRow(at: indexPath) as? TaskTableViewCell {
            cell.isFinish = true
        }

        if let cell = tableView.cellForRow(at: indexPath) as? TaskTableViewADCell {
            let adView = ADView(frame: UIScreen.main.bounds)
            adView.cell = cell
            adView.taskInfo = info
            keyWindow?.addSubview(adView)
        }
        
    }
    
}
