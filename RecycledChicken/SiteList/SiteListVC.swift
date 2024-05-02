//
//  SiteListVC.swift
//  RecycledChicken
//
//  Created by Claud on 2024/5/2.
//

import UIKit
import WebKit
class SiteListVC: CustomVC {
    
    @IBOutlet weak var webView:WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "siteList".localized
        // Do any additional setup after loading the view.
        UIInit()
    }
    
    private func UIInit() {
        var urlStr = APIUrl.siteList
        if getLanguage() == .english {
            urlStr = APIUrl.siteListEnglish
        }
        if let url = URL(string: urlStr) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultNavigationBackBtn2()
    }

}
