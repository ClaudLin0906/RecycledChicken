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
    
    private func customInit(){
        loadNibContent()
        let request = URLRequest(url: URL(string: APIUrl.domainName + APIUrl.getAd)!)
        webView.load(request)
        timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: false) { timer in
            self.isFinishAction()
        }
    }
}
