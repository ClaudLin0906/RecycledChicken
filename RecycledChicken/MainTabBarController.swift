//
//  MainTabBarController.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/7.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    let tabbarTitle:[String] =
    [
        "點數",
        "門市",
        "首頁",
        "AR",
        "任務"
    ]
    
    let noSelectImages:[UIImage?] =
    [
        UIImage(named: "orderCopy"),
        UIImage(named: "orderCopy"),
        UIImage(named: "orderCopy"),
        UIImage(named: "orderCopy"),
        UIImage(named: "orderCopy")
    ]
    
    let selectImages:[UIImage?] =
    [
        UIImage(named: "orderCopy"),
        UIImage(named: "orderCopy"),
        UIImage(named: "orderCopy"),
        UIImage(named: "orderCopy"),
        UIImage(named: "orderCopy")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupItems()
//        if #available(iOS 15.0, *) {
//            updateTabBarAppearance()
//        } else {
//            tabBar.tintColor = CommonColor.shared.color2
//            tabBar.isTranslucent = false
//        }
    }
    

    @available(iOS 15.0, *)
    private func updateTabBarAppearance(){
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = CommonColor.shared.color2
        tabBarAppearance.backgroundImage = UIImage(named: "グループ 974")
        tabBar.standardAppearance = tabBarAppearance
        tabBar.scrollEdgeAppearance = tabBarAppearance
    }
    

    private func setupItems() {
        for (index,value) in tabbarTitle.enumerated(){
            let noSelectImage = noSelectImages[index]!.withRenderingMode(.alwaysOriginal)
            let SelectImage = selectImages[index]!.withRenderingMode(.alwaysOriginal)
            if let nc = viewControllers![index] as? UINavigationController {
                nc.tabBarItem.title = value
                nc.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.brown], for: .normal)
                nc.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.brown], for: .selected)
                nc.tabBarItem.image = noSelectImage
                nc.tabBarItem.selectedImage = SelectImage
            }
        }
        let bgView = UIImageView(image: UIImage(named: "グループ 974"))
        bgView.frame = CGRect(x: 0, y: 0, width: tabBar.bounds.width, height: tabBar.bounds.height + 30)
        self.tabBar.addSubview(bgView)
        self.tabBar.sendSubviewToBack(bgView)

    }

}
