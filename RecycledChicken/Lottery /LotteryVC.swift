//
//  LotteryVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/10.
//

import UIKit

class LotteryVC: CustomVC {
    
    @IBOutlet weak var tableView:UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "抽獎專區"
        setDefaultNavigationBackBtn2()
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit(){
        tableView.setSeparatorLocation()
    }

}

extension LotteryVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LotteryTableViewCell.identifier, for: indexPath) as! LotteryTableViewCell
        return cell
    }
    
    
}
