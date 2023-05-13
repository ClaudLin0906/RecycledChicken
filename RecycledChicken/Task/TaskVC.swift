//
//  TaskVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/11.
//

import UIKit

class TaskVC: CustomRootVC {
    
    @IBOutlet weak var tableView:UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit(){
        
    }

}

extension TaskVC:UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as! TaskTableViewCell
        
        if row == 0 {
            cell.title.text = "寶特瓶回收10瓶"
        }
        
        if row == 1 {
            cell.title.text = "電池回收10瓶"
        }
        
        if row == 2 {
            cell.title.text = "廣告點擊"
        }
        
        if row == 3 {
            cell.title.text = "社群分享"
        }
        
        return cell
    }
    
}
