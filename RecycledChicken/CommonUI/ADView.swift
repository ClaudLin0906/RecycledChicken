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
    
    var cell:TaskTableViewADCell?
    
    var taskInfo:TaskInfo?
    
    var timer:Timer?
    
    enum ADType{
        case isHome
        case isTask
    }
    
    var type:ADType = .isHome
    
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
        timer?.invalidate()
        timer = nil
        self.removeFromSuperview()
    }
    
    private func isFinishAction() {
        cell?.taskInfo = taskInfo
        cell?.finishAction()
    }
    
    private func taskAction(){
        let request = URLRequest(url: URL(string: APIUrl.taskAD)!)
        webviewLoadAction(request)
    }
    
    private func webviewLoadAction(_ request:URLRequest){
        DispatchQueue.main.async { [self] in
            webView.load(request)
        }
        timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: false) { timer in
            self.isFinishAction()
        }
    }
    
    private func HomeAction(){        
        NetworkManager.shared.getJSONBody(urlString: APIUrl.domainName + APIUrl.getAd) { (data, statusCode, errorMSG) in
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
        switch type {
        case.isHome:
            HomeAction()
        case .isTask:
            taskAction()
        }
    }
}
