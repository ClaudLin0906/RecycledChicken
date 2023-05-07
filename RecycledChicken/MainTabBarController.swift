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
        UIImage(named: "グループ 76"),
        UIImage(named: "グループ 77"),
        UIImage(named: "组 404"),
        UIImage(named: "グループ 463"),
        UIImage(named: "グループ 467")
    ]
    
    let selectImages:[UIImage?] =
    [
        UIImage(named: "グループ 76"),
        UIImage(named: "グループ 77"),
        UIImage(named: "组 404"),
        UIImage(named: "グループ 463"),
        UIImage(named: "グループ 467")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupItems()
        if #available(iOS 15.0, *) {
            updateTabBarAppearance()
        } else {
            tabBar.isTranslucent = false
        }
    }
    

    @available(iOS 15.0, *)
    private func updateTabBarAppearance(){
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBar.standardAppearance = tabBarAppearance
        tabBar.scrollEdgeAppearance = tabBarAppearance
    }
    
    private func updateTabBarItemAppearance(appearance:UITabBarItemAppearance){
//        appearance.normal.iconColor =
    }
    

    private func setupItems() {
        
        for (index,value) in tabbarTitle.enumerated(){
            let noSelectImage = noSelectImages[index]!
            let SelectImage = selectImages[index]!
            if let nc = viewControllers![index] as? UINavigationController {
                nc.tabBarItem.title = value
                nc.tabBarItem.image = noSelectImage
                nc.tabBarItem.selectedImage = SelectImage
            }
        }
    }

}
