//
//  BarCodeView.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/8.
//

import UIKit

class BarCodeView: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var barcodeImageView:UIImageView!
    
    @IBOutlet weak var codeLabel:UILabel!
    
    @IBOutlet weak var titleLabel:UILabel!

    var code = ""
    {
        willSet {
            codeLabel.text = newValue
            if let barCodeImage = generateBarCode(from: newValue) {
                barcodeImageView.image = barCodeImage
            }
        }
    }

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
    
    func setTitle(){
        if CurrentUserInfo.shared.isGuest {
            titleLabel.text = "訪客模式"
        }else {
            titleLabel.text = "會員條碼"
        }
    }

}
