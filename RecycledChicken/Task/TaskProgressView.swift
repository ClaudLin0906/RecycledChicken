//
//  TaskProgressView.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/16.
//

import UIKit

class TaskProgressView: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var percentLabel:UILabel!
    
    @IBOutlet weak var percentprogressView:UIProgressView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }
    
    private func customInit(){
        loadNibContent()
    }
    
    func setPercent(_ molecular:Int, denominator:Int){
        percentLabel.text = "\(molecular)/\(denominator)"
        percentprogressView.progress = Float(molecular/denominator)
    }

}
