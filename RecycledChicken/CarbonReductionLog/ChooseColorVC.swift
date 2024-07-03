//
//  ChooseColorVC.swift
//  RecycledChicken
//
//  Created by ClaudLin on 2024/7/3.
//

import UIKit

protocol ChooseColorVCDelete {
    func chooseColor(_ color:UIColor )
}

class ChooseColorVC: UIViewController {
    
    var delegate:ChooseColorVCDelete?
    
    @IBOutlet weak var bottleButton:UIButton!
    
    @IBOutlet weak var batteryButton:UIButton!
    
    @IBOutlet weak var papperCubButton:UIButton!
    
    @IBOutlet weak var aluminumButton:UIButton!
    
//    @IBOutlet weak var publicTransportButton:UIButton!
    
    private  var selectedColor:UIColor?

    override func viewDidLoad() {
        super.viewDidLoad()
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit() {
        bottleButton.setImage(UIImage(named: RecyceledSort.bottle.getInfo().iconName), for: .normal)
        batteryButton.setImage(UIImage(named: RecyceledSort.battery.getInfo().iconName), for: .normal)
        aluminumButton.setImage(UIImage(named: RecyceledSort.aluminumCan.getInfo().iconName), for: .normal)
        papperCubButton.setImage(UIImage(named: RecyceledSort.papperCub.getInfo().iconName), for: .normal)
//        publicTransportButton.setImage(UIImage(named: RecyceledSort..getInfo().iconName), for: .normal)
    }
    
    @IBAction func tapButton(_ sender:UIButton) {
        if sender == bottleButton {
            delegate?.chooseColor(RecyceledSort.bottle.getInfo().color)
        }
        
        if sender == batteryButton {
            delegate?.chooseColor(RecyceledSort.battery.getInfo().color)
        }
        
        if sender == aluminumButton {
            delegate?.chooseColor(RecyceledSort.aluminumCan.getInfo().color)
        }
        
        if sender == papperCubButton {
            delegate?.chooseColor(RecyceledSort.papperCub.getInfo().color)
        }
        
    }
    
    @IBAction func confirm(_ sender:UIButton) {
//        guard let selectedColor = selectedColor else { return }
//        delegate?.chooseColor(selectedColor)
    }

    @IBAction func cancel(_ sender:UIButton) {
        self.dismiss(animated: true)
    }

}
