//
//  IllustratedGuideVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2024/2/25.
//

import UIKit

class IllustratedGuideVC: CustomVC {
    
    @IBOutlet weak var tableView:UITableView!
    
    private var tableViewDatas = illustratedGuideModelDatas

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
