//
//  ProductVC.swift
//  RecycledChicken
//
//  Created by ClaudLin on 2024/5/28.
//

import UIKit
import WebKit
class ProductVC: CustomVC {
    
    @IBOutlet weak var webView:WKWebView!
    
//    private var buenocoopURL = URL(string: "https://www.buenocoop.com/")!
    
    private var buenocoopURL:URL = {
        var isFirstProduct = UserDefaults().bool(forKey: UserDefaultKey.shared.isFirstProduct) 
        var urlStr = ""
        if isFirstProduct {
            urlStr = "https://www.buenocoop.com/login"
        }
        if !isFirstProduct {
            urlStr = "https://www.buenocoop.com/"
        }
        return URL(string: urlStr)!
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "商品專區"
        UIInit()
        // Do any additional setup after loading the view.
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
    
    @IBAction func openBorwser(_ sender:UIButton) {
        if UIApplication.shared.canOpenURL(buenocoopURL) {
            UIApplication.shared.open(buenocoopURL)
        }
    }

}

extension ProductVC:WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UserDefaults().set(false, forKey: UserDefaultKey.shared.isFirstProduct)
    }
}

extension ProductVC:WKUIDelegate {
    
}
