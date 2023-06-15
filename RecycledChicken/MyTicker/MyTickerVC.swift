//
//  MyTickerVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/11.
//

import UIKit

class MyTickerVC: CustomVC {
    
    @IBOutlet weak var tableView:UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "我的票夾"
        setDefaultNavigationBackBtn2()
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit(){
        
    }

}

extension MyTickerVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        view.safeAreaLayoutGuide.layoutFrame.height * 0.22
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyTickerTableViewCell.identifier, for: indexPath) as! MyTickerTableViewCell
        return cell
    }
    
}
