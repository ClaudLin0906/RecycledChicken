//
//  CustomVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/8.
//

import UIKit

class CustomVC: UIViewController {
            
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.navigationBar.titleTextAttributes = attributes
        let closeTap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard(_:)))
        closeTap.cancelsTouchesInView = false
        view.addGestureRecognizer(closeTap)

    }

    @objc private func backBtnPressed() {
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        }else{
            print("navigationController is nil")
        }
    }
    
    func setDefaultNavigationBackBtn() {
        navigationController?.navigationBar.isTranslucent = true
        let backBtn = UIBarButtonItem(image: UIImage(named: "路径 273"), style: .plain, target: self, action: #selector(backBtnPressed))
        backBtn.tintColor = .white
        navigationItem.leftBarButtonItem = backBtn
        
        let barAppearance =  UINavigationBarAppearance()
        barAppearance.configureWithTransparentBackground()
        barAppearance.backgroundColor = CommonColor.shared.color1
        barAppearance.titleTextAttributes = attributes
        navigationController?.navigationBar.standardAppearance = barAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        
    }
    
    func setDefaultNavigationBackBtn2() {
        navigationController?.navigationBar.isTranslucent = true
        let backBtn = UIBarButtonItem(image: UIImage(named: "路径 273"), style: .plain, target: self, action: #selector(backBtnPressed))
        backBtn.tintColor = .black
        navigationItem.leftBarButtonItem = backBtn
        let barAppearance =  UINavigationBarAppearance()
        barAppearance.configureWithTransparentBackground()
        barAppearance.backgroundColor = .clear
        barAppearance.titleTextAttributes = attributes2
        navigationController?.navigationBar.standardAppearance = barAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
    }
    
    @objc private func closeKeyboard(_ tap:UITapGestureRecognizer){
        view.endEditing(true)
    }

}

extension CustomVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
