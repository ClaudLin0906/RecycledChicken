//
//  LanguageSettingVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2024/2/24.
//

import UIKit

class LanguageSettingVC: CustomVC {
    
    @IBOutlet weak var tableView:UITableView!
    
    private var tableViewDatas:[LanguageSetting] = [
        LanguageSetting(language: .traditionalChinese, displayText: "繁體中文"),
        LanguageSetting(language: .english, displayText: "英文 English")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "languageSetting".localized
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
    
    private func changeLanguage(_ language:Language) {
        Setting.shared.language = language
        setLanguage(language)
    }

}

extension LanguageSettingVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = tableViewDatas[indexPath.row]
        if Setting.shared.language != type.language {
            let action = UIAlertAction(title: "confirm".localized, style: .default) { _ in
                self.changeLanguage(type.language)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                exit(2)
            }
            let cancelAction = UIAlertAction(title: "cancel".localized, style: .cancel)
            showAlert(VC: self, title: "reStartOfChangeLanuage".localized, alertAction: action, cancelAction: cancelAction)
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


