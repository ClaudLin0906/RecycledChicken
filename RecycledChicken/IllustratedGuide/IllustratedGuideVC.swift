//
//  IllustratedGuideVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2024/2/25.
//

import UIKit

class IllustratedGuideVC: CustomVC {
    
    @IBOutlet weak var tableView:UITableView!
    
    private var tableViewDatas:[IllustratedGuideTableData] = {
        var illustratedGuideTableDatas:[IllustratedGuideTableData] = []
        IllustratedGuideModelLevel.allCases.forEach { illustratedGuideModelLevel in
            var isRead = false
            if let profileInfo = CurrentUserInfo.shared.currentProfileNewInfo, let levelInfo = profileInfo.levelInfo, let level = levelInfo.progress, level >= getIllustratedGuide(illustratedGuideModelLevel).level {
                isRead = true
            }
            illustratedGuideTableDatas.append( IllustratedGuideTableData(illustratedGuideModelLevel: illustratedGuideModelLevel, isRead: isRead))
        }
        return illustratedGuideTableDatas
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "碳竹雞圖鑑"
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

extension IllustratedGuideVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard tableViewDatas[indexPath.row].isRead else { return }
        if let navigationController = self.navigationController, let VC = UIStoryboard(name: "IllustratedContent", bundle: Bundle.main).instantiateViewController(identifier: "IllustratedContent") as? IllustratedContentVC {
            VC.illustratedGuideModelLevel = tableViewDatas[indexPath.row].illustratedGuideModelLevel
            pushVC(targetVC: VC, navigation: navigationController)
        }
    }
}

extension IllustratedGuideVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IllustratedGuideTableViewCell", for: indexPath) as! IllustratedGuideTableViewCell
        let row = indexPath.row
        cell.setCell(tableViewDatas[row])
        return cell
    }
    
}
