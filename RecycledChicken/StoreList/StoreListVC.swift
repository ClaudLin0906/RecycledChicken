//
//  StoreListVC.swift
//  RecycledChicken
//
//  Created by Claud on 2023/5/12.
//

import UIKit

class StoreListVC: CustomVC {

    @IBOutlet weak var storeListTableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "門市列表"
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit(){
        storeListTableView.setSeparatorLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultNavigationBackBtn2()
    }


}

extension StoreListVC:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StoreListTableViewCell.identifier, for: indexPath) as! StoreListTableViewCell
        return cell
    }
    
}
