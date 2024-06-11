//
//  ADView.swift
//  RecycledChicken
//
//  Created by Claud on 2023/7/17.
//

import UIKit
import WebKit

class ADView: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var countdownLabel:UILabel!
    
    @IBOutlet weak var closeBtn:UIButton!
    
    var taskTableViewADCell:TaskTableViewADCell?
    
    var taskTableViewPartnerCell:TaskTableViewPartnerCell?
    
    var type:ADType = .isHome
    
    var taskInfo:TaskInfo?
    {
        didSet{
            if taskInfo != nil {
                switch type {
                case.isHome:
                    homeAction()
                case .isTask:
                    taskAction()
                }
            }
        }
    }
        
    private var remainingSeconds: Int = 30
    
    private var countdownTimer: Timer?
    
    enum ADType{
        case isHome
        case isTask
    }
    
    private var isFirstTime = true
    
    init(frame: CGRect, type:ADType) {
        super.init(frame: frame)
        self.type = type
        customInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }
    
    @IBAction func cancel(_ sender:UIButton){
        self.removeFromSuperview()
    }
    
    private func isFinishAction() {
        if let taskTableViewADCell = taskTableViewADCell {
            taskTableViewADCell.finishAction()
        }
        
        if let taskTableViewPartnerCell = taskTableViewPartnerCell {
            taskTableViewPartnerCell.finishAction()
        }
        
    }
    
    private func taskAction() {
        if let urlStr = taskInfo?.url, let url = URL(string: urlStr) {
            let request = URLRequest(url: url)
            webviewLoadAction(request)
            countdownLabel.isHidden = false
        }
    }
    
    private func webviewLoadAction(_ request:URLRequest) {
        
        DispatchQueue.main.async { [self] in
            webView.load(request)
        }
    }
    
    private func homeAction(){
        NetworkManager.shared.getJSONBody(urlString: APIUrl.domainName + APIUrl.getAd) { data, statusCode, errorMSG in
            guard let data = data, let urlStr = String(data: data, encoding: .utf8), let url = URL(string: urlStr) else {
                return
            }
            DispatchQueue.main.async { [self] in
                webView.load(URLRequest(url: url))
            }
        }
    }
    
    private func customInit(){
        loadNibContent()
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear
        webView.uiDelegate = self
        webView.navigationDelegate = self
        switch type {
        case .isHome:
            homeAction()
        case .isTask:
            taskAction()
        }
    }
}


extension ADView: WKUIDelegate {
    
}

extension ADView: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        switch type {
        case .isHome:
            closeBtn.isHidden = false
        case .isTask:
            guard isFirstTime else{ return }
            isFirstTime = false
            countdownLabel.isHidden = false
            countdownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [self] timer in
                print("remainingSeconds \(remainingSeconds)")
                remainingSeconds -= 1
                countdownLabel.text = "\(remainingSeconds)"
                if remainingSeconds == 0 {
                    countdownLabel.isHidden = true
                    closeBtn.isHidden = false
                    countdownTimer?.invalidate()
                    countdownTimer = nil
                    isFinishAction()
                }
            })
            RunLoop.main.add(countdownTimer!, forMode: .common)
        }
    }
}
