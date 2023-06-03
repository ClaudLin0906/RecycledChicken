//
//  ARVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/11.
//

import UIKit

class ARVC: CustomRootVC {

    private var cameraView: CircularCameraView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit(){
        cameraView = CircularCameraView()
        view.addSubview(cameraView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        cameraView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        cameraView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        cameraView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        cameraView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    @IBAction func goToProductDescription(_ sender:UIButton) {
        if let navigationController = self.navigationController, let VC = UIStoryboard(name: "ProductDescription", bundle: Bundle.main).instantiateViewController(identifier: "ProductDescription") as? ProductDescriptionVC {
            pushVC(targetVC: VC, navigation: navigationController)
        }
    }

}
