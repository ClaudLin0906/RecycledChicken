//
//  ConnectCompanyWebViewVC.swift
//  RecycledChicken
//
//  Created by ClaudLin on 2024/6/12.
//

import UIKit
import WebKit
class ConnectCompanyWebViewVC: CustomVC {
    
    @IBOutlet weak var webView:WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit() {
        title = "contactPartnership".localized
        webView.load(URLRequest(url: URL(string: WebViewUrl.ConnectCompanyURL)!))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultNavigationBackBtn2()
    }

}
