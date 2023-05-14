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
        UIImage(named: "グループ 457"),
        UIImage(named: "orderCopy"),
        UIImage(named: "orderCopy"),
        UIImage(named: "orderCopy"),
        UIImage(named: "orderCopy")
    ]
    
    let selectImages:[UIImage?] =
    [
        UIImage(named: "fav-o"),
        UIImage(named: "orderCopy"),
        UIImage(named: "orderCopy"),
        UIImage(named: "orderCopy"),
        UIImage(named: "orderCopy")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupItems()
        if #available(iOS 15.0, *) {
            updateTabBarAppearance()
        } else {
            tabBar.tintColor = .white
            tabBar.isTranslucent = false
        }
    }
    

    @available(iOS 15.0, *)
    private func updateTabBarAppearance(){
        let tabBarItemAppearance = UITabBarItemAppearance()
        tabBarItemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        tabBarItemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.stackedLayoutAppearance = tabBarItemAppearance
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = CommonColor.shared.color5
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
                nc.tabBarItem.image = noSelectImage
                nc.tabBarItem.selectedImage = SelectImage
                nc.tabBarController?.tabBar.backgroundColor = .brown
            }
        }
    }

}
