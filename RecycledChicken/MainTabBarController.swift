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
        "point".localized,
        "store".localized,
        "home".localized,
//        "AR",
        "task".localized
    ]
    
    let noSelectImages:[UIImage?] =
    [
        UIImage(named: "start 1"),
        UIImage(named: "location"),
        UIImage(named: "组 226"),
        UIImage(named: "task")
    ]
    
    let selectImages:[UIImage?] =
    [
        UIImage(named: "fav-o"),
        UIImage(named: "location-o"),
        UIImage(named: "home"),
//        UIImage(named: "scan-o"),
        UIImage(named: "orderCopy")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupItems()
        updateTabBarAppearance()
//        if #available(iOS 15.0, *) {
//
//        } else {
//            tabBar.tintColor = .white
//            tabBar.isTranslucent = false
//            tabBar.barTintColor = CommonColor.shared.color5
//
//        }
    }

    private func updateTabBarAppearance(){
        let tabBarItemAppearance = UITabBarItemAppearance()
        tabBarItemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        tabBarItemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.stackedLayoutAppearance = tabBarItemAppearance
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = CommonColor.shared.color5
        tabBarAppearance.backgroundImage = UIImage(named: "bottom")
        if #available(iOS 15.0, *) {
            tabBarAppearance.stackedLayoutAppearance.selected.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 15)
            tabBarAppearance.stackedLayoutAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 15)
            tabBar.scrollEdgeAppearance = tabBarAppearance
        }
        tabBar.standardAppearance = tabBarAppearance
    }
    

    private func setupItems() {
        for (index,value) in tabbarTitle.enumerated(){
            let noSelectImageSize = CGSize(width: 40, height: 40)
            let SelectImageSize = CGSize(width: 55, height: 55)
            let noSelectImage = noSelectImages[index]!.resize(targetSize: noSelectImageSize).withRenderingMode(.alwaysOriginal)
            let SelectImage = selectImages[index]!.resize(targetSize: SelectImageSize).withRenderingMode(.alwaysOriginal)
            if let nc = viewControllers![index] as? UINavigationController {
                nc.tabBarItem.title = value
                nc.tabBarItem.image = noSelectImage
                nc.tabBarItem.selectedImage = SelectImage
                nc.tabBarController?.tabBar.backgroundColor = .brown
            }
        }
    }

}

