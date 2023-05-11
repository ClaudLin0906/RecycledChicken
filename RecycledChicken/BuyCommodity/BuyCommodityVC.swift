//
//  BuyCommodityVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/11.
//

import UIKit

class BuyCommodityVC: CustomVC {
    
    @IBOutlet weak var spendPointView:SpendPointView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "購買商品序號"
        setDefaultNavigationBackBtn2()
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit(){
        spendPointView.setConfirmBtnTitle("確認兌換")
    }

}
