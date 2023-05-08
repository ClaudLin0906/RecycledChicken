//
//  Common.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/6.
//

import Foundation
import UIKit

class CommonColor {
    
    static let shared = CommonColor()
    
    var color1 = #colorLiteral(red: 0.3411764706, green: 0.4470588235, blue: 0.4078431373, alpha: 1)

    var color2 = #colorLiteral(red: 0.937254902, green: 0.9137254902, blue: 0.8156862745, alpha: 1)

    var color3 = #colorLiteral(red: 0.8862745098, green: 0.7607843137, blue: 0.4901960784, alpha: 1)

    var color4 = #colorLiteral(red: 0.9490196078, green: 0.9411764706, blue: 0.9058823529, alpha: 1)

    var color5 = #colorLiteral(red: 0.6862745098, green: 0.5764705882, blue: 0.4431372549, alpha: 1)

    var color6 = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1)

    var color7 = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)

    var color8 = #colorLiteral(red: 0.8980392157, green: 0.5333333333, blue: 0.368627451, alpha: 1)

    var color9 = #colorLiteral(red: 0.8274509804, green: 0.6901960784, blue: 0.4156862745, alpha: 1)
    
    var color10 = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
        
    var color11 = #colorLiteral(red: 0.1019607843, green: 0.1019607843, blue: 0.1019607843, alpha: 1)
    
}

protocol NibOwnerLoadable: AnyObject {
    static var nib: UINib { get }
}


func generateBarCode(from string: String) -> UIImage? {
    let data = string.data(using: .ascii)
    if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
        filter.setValue(data, forKey: "inputMessage")
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        
        if let output = filter.outputImage?.transformed(by: transform) {
            return UIImage(ciImage: output)
        }
    }
    return nil
}


func pushVC(targetVC:UIViewController, navigation:UINavigationController) {
    DispatchQueue.main.async {
        if !(navigation.topViewController?.isKind(of: targetVC.classForCoder))!{
            targetVC.hidesBottomBarWhenPushed = true
            navigation.pushViewController(targetVC, animated: true)
        }
    }
}
