//
//  CustomVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/8.
//

import UIKit

class CustomVC: UIViewController {
    
    var appearance = UINavigationBarAppearance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        let closeTap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard(_:)))
        view.addGestureRecognizer(closeTap)
    }

    @objc private func backBtnPressed(){
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        }else{
            print("navigationController is nil")
        }
    }
    
    func setDefaultNavigationBackBtn(){
        let backBtn = UIBarButtonItem(image: UIImage(named: "路径 273"), style: .plain, target: self, action: #selector(backBtnPressed))
        backBtn.tintColor = .white
        navigationItem.leftBarButtonItem = backBtn
        appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = CommonColor.shared.color1
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        navigationController?.navigationBar.isTranslucent = false
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
