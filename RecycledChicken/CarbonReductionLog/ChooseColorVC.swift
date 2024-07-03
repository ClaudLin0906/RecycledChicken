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
    
    private  var selectedColor:UIColor?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func confirm(_ sender:UIButton) {
        guard let selectedColor = selectedColor else { return }
        delegate?.chooseColor(selectedColor)
    }

    @IBAction func cancel(_ sender:UIButton) {
        self.dismiss(animated: true)
    }

}
