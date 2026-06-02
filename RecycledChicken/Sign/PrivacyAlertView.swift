//
//  PrivacyAlertView.swift
//  RecycledChicken
//
//  Created by Antigravity on 2026/06/02.
//

import UIKit
import WebKit

class PrivacyAlertView: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var agreeButton: UIButton!
    @IBOutlet weak var disagreeButton: UIButton!
    
    var onAgree: (() -> Void)?
    var onCancel: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }
    
    private func customInit() {
        loadNibContent()
        
        webView.backgroundColor = .clear
        webView.isOpaque = false
        
        agreeButton.layer.cornerRadius = 20
        disagreeButton.layer.cornerRadius = 20
        disagreeButton.layer.borderWidth = 1
        disagreeButton.layer.borderColor = UIColor(red: 0.24, green: 0.36, blue: 0.31, alpha: 1.0).cgColor
        
        if let url = URL(string: WebViewUrl.PrivacyPolicyURL) {
            webView.load(URLRequest(url: url))
        }
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        onAgree?()
        self.removeFromSuperview()
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        onCancel?()
        self.removeFromSuperview()
    }
}
