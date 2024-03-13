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
//        switch language {
//        case .traditionalChinese:
//            
//        case .english:
//
//        }
    }

}

extension LanguageSettingVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = tableViewDatas[indexPath.row]
        if Setting.shared.language != type.language {
            let action = UIAlertAction(title: "confirm".localized, style: <#T##UIAlertAction.Style#>, handler: <#T##((UIAlertAction) -> Void)?##((UIAlertAction) -> Void)?##(UIAlertAction) -> Void#>)
            showAlert(VC: self, title: "reStartOfChangeLanuage".localized)
//            changeLanguage(type.language)
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
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


