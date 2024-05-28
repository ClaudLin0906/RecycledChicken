//
//  CommodityVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2024/5/28.
//

import UIKit
import WebKit
class CommodityVC: CustomVC {
    
    @IBOutlet weak var webView:WKWebView!
    
    private var buenocoopURL = URL(string: "https://www.buenocoop.com/")

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "商品專區"
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit() {
        let request = URLRequest(url: buenocoopURL!)
        webView.load(request)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultNavigationBackBtn2()
    }
    
    @IBAction func openByBrowser(_ sender:UIButton) {
        if UIApplication.shared.canOpenURL(buenocoopURL!) {
            UIApplication.shared.open(buenocoopURL!)
        }
    }

}
