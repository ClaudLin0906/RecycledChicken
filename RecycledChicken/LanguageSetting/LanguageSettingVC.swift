//
//  LanguageSettingVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2024/2/24.
//

import UIKit

class LanguageSettingVC: CustomVC {
    
    @IBOutlet weak var tableView:UITableView!
    
    private var tableViewDatas = Language.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "語言設定"
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit(){
        tableView.setSeparatorLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultNavigationBackBtn2()
    }

}

extension LanguageSettingVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = tableViewDatas[indexPath.row]
        Setting.shared.language = type
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}

extension LanguageSettingVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageTableViewCell", for: indexPath) as! LanguageTableViewCell
        cell.setCell(tableViewDatas[indexPath.row])
        return cell
    }
    
}


