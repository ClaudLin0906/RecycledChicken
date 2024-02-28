//
//  ProductVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2024/2/28.
//

import UIKit
import WebKit
class ProductVC: CustomVC {
    
    @IBOutlet weak var webView:WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "商品專區"
        // Do any additional setup after loading the view.
        UIInit()
    }
    
    private func UIInit() {
        let request = URLRequest(url: URL(string: "https://tw.yahoo.com/")!)
        webView.load(request)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultNavigationBackBtn2()
    }

}
