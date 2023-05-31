//
//  CustomTabbar.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/31.
//

import UIKit

class CustomTabbar: UITabBar {

    var tabBarHeight: CGFloat = 60
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let superSize = super.sizeThatFits(size)

        return CGSize(width: superSize.width, height: self.tabBarHeight)
    }


}
