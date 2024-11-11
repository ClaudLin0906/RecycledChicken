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
    
    @UserDefault(UserDefaultKey.shared.isFirstProduct, defaultValue: false) var isFirstProduct:Bool
    
    private lazy var buenocoopURL:URL = {
        var urlStr = ""
        if isFirstProduct {
            urlStr = "https://www.buenocoop.com/login"
        }
        if !isFirstProduct {
            urlStr = "https://www.buenocoop.com/"
        }
        return URL(string:urlStr)!
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "商品專區"
        // Do any additional setup after loading the view.
        UIInit()
    }
    
    private func UIInit() {
        webView.navigationDelegate = self
        webView.uiDelegate = self
        let request = URLRequest(url: buenocoopURL)
        webView.load(request)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultNavigationBackBtn2()
    }

    @IBAction func openBrowser(_ sender:UIButton) {
        if UIApplication.shared.canOpenURL(buenocoopURL) {
            UIApplication.shared.open(buenocoopURL)
        }
    }
    
}

extension ProductVC:WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        isFirstProduct = false
    }
}

extension ProductVC:WKUIDelegate {
    
}
