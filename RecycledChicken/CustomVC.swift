//
//  CustomVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/8.
//

import UIKit

class CustomVC: UIViewController {
    
    let attributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.font: UIFont(name: "GenJyuuGothic-Normal", size: 17)!,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.kern: 5 // 設定字距
    ]
    
    let attributes2: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.font: UIFont(name: "GenJyuuGothic-Normal", size: 17)!,
        NSAttributedString.Key.foregroundColor: UIColor.black,
        NSAttributedString.Key.kern: 5 // 設定字距
    ]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        let closeTap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard(_:)))
        closeTap.cancelsTouchesInView = false
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
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = CommonColor.shared.color1
        appearance.titleTextAttributes = attributes
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        navigationController?.navigationBar.isTranslucent = false
    }
    
    func setDefaultNavigationBackBtn2(){
        let backBtn = UIBarButtonItem(image: UIImage(named: "路径 273"), style: .plain, target: self, action: #selector(backBtnPressed))
        backBtn.tintColor = .black
        navigationItem.leftBarButtonItem = backBtn
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
        appearance.titleTextAttributes = attributes2
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        navigationController?.navigationBar.isTranslucent = true
    }
    
    @objc private func closeKeyboard(_ tap:UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    func setBackgroundImage(){
        let imageView = UIImageView(frame: view.frame)
        imageView.image = UIImage(named: "グループ 1089")
        imageView.contentMode = .scaleAspectFill
        view.addSubview(imageView)
    }

}

extension CustomVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
