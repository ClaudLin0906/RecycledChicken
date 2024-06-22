//
//  CustomerContactVC.swift
//  RecycledChicken
//
//  Created by sj on 2024/6/8.
//

import UIKit
import WebKit
class CustomerContactVC: CustomVC {
    
    @IBOutlet weak var webView:WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "customerContact".localized
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit(){
        webView.load(URLRequest(url: URL(string: WebViewUrl.CustomerContactURL)!))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultNavigationBackBtn2()
    }

}
