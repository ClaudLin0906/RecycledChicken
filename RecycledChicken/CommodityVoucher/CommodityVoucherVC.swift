//
//  CommodityVoucherVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/10.
//

import UIKit

class CommodityVoucherVC: CustomVC {
    
    @IBOutlet weak var tableView:UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "商品禮卷"
        setDefaultNavigationBackBtn2()
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit(){
        
    }
    
}

extension CommodityVoucherVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let navigationController = self.navigationController, let VC = UIStoryboard(name: "BuyCommodity", bundle: Bundle.main).instantiateViewController(identifier: "BuyCommodity") as? BuyCommodityVC {
            pushVC(targetVC: VC, navigation: navigationController)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        view.safeAreaLayoutGuide.layoutFrame.height * 0.22
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommodityVoucherTableViewCell.identifier, for: indexPath) as! CommodityVoucherTableViewCell
        return cell
    }
    
}
