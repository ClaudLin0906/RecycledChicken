//
//  PrivacyPolicyVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/10.
//

import UIKit
import WebKit
class PrivacyPolicyVC: CustomVC {
    
    @IBOutlet weak var webView:WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "termsPrivacyPolicy".localized
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit(){
        webView.load(URLRequest(url: URL(string: WebViewUrl.PrivacyPolicyURL)!))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultNavigationBackBtn2()
    }

}
