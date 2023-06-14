//
//  PersonMessageVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/9.
//

import UIKit

class PersonMessageVC: CustomVC {
    
    @IBOutlet weak var personMessageTableView:UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "個 人 訊 息"
        setDefaultNavigationBackBtn2()
        personMessageTableView.setSeparatorLocation()
        // Do any additional setup after loading the view.
    }

}

extension PersonMessageVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let navigationController = self.navigationController, let VC = UIStoryboard(name: "PersonMessageContent", bundle: Bundle.main).instantiateViewController(identifier: "PersonMessageContent") as? PersonMessageContentVC {
            pushVC(targetVC: VC, navigation: navigationController)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PersonMessageTableViewCell.identifier, for: indexPath) as! PersonMessageTableViewCell
        return cell
    }
    
    
}
