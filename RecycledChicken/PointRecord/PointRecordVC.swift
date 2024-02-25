//
//  PointRecordVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2024/2/25.
//

import UIKit
import DropDown
import SkeletonView

class PointRecordVC: CustomVC {
    
    @IBOutlet weak var tableView:UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "點數紀錄"
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit() {
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultNavigationBackBtn()
    }
}

extension PointRecordVC: UITableViewDelegate {
    
}

extension PointRecordVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PointRecordTableViewCell", for: indexPath) as! PointRecordTableViewCell
        return cell
    }
    
}
