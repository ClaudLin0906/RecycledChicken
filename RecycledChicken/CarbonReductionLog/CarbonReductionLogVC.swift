//
//  CarbonReductionLogVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/8.
//

import UIKit
import MKRingProgressView
class CarbonReductionLogVC: CustomVC {
        
    @IBOutlet weak var recycleBtn:UIButton!
    
    @IBOutlet weak var progressGroup:RingProgressGroupView!
    
    @IBOutlet weak var carbonReductionNumber:UILabel!
    
    let parties = ["PET", "BATT"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "減碳歷程"
        UIInit()
        setDefaultNavigationBackBtn()
        
    }

    private func UIInit() {
        recycleBtn.layer.borderWidth = 1
        recycleBtn.layer.borderColor = #colorLiteral(red: 0.7647058964, green: 0.7647058964, blue: 0.7647058964, alpha: 1)
        
        progressGroup.ring1.accessibilityLabel = NSLocalizedString("Move", comment: "")
        progressGroup.ring2.accessibilityLabel = NSLocalizedString("Exercise", comment: "")
        progressGroup.title.font = carbonReductionNumber.font
        progressGroup.title.text = "Congratulations!\n恭喜你電池回收量\n超額完成!"
        // Do any additional setup after loading the view.
        
        UIView.animate(withDuration: 0.5) { [self] in
            let random = Double(arc4random() % 200) / 100.0
            progressGroup.ring1.progress = 0.7
            progressGroup.ring2.progress = 0.4
        }

    }
    
    
    @IBAction func goToRecycleLog(_ sender:UIButton) {
        if let navigationController = self.navigationController, let VC = UIStoryboard(name: "RecycleLog", bundle: Bundle.main).instantiateViewController(identifier: "RecycleLog") as? RecycleLogVC {
            pushVC(targetVC: VC, navigation: navigationController)
        }
    }
}

