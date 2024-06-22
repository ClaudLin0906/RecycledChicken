//
//  MallProductVC.swift
//  RecycledChicken
//
//  Created by ClaudLin on 2024/6/5.
//

import UIKit
import WebKit
class MallProductVC: CustomVC {
    
    @IBOutlet weak var webView:WKWebView!
    
    private var productURL:URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        UIinit()
        // Do any additional setup after loading the view.
    }
    
    func setProductURL(_ productURL:URL) {
        self.productURL = productURL
    }
    
    private func UIinit() {
        if let productURL = productURL {
            var request = URLRequest(url: productURL)
            webView.load(request)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultNavigationBackBtn2()
    }

}
