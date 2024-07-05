//
//  ChooseColorVC.swift
//  RecycledChicken
//
//  Created by ClaudLin on 2024/7/3.
//

import UIKit

protocol ChooseColorVCDelete {
    func chooseColor(_ color:UIColor )
    func cancel()
}

class ChooseColorVC: UIViewController {
    
    var delegate:ChooseColorVCDelete?
    
    @IBOutlet weak var stackView:UIStackView!
        
    private lazy var bottleItemCellView:CarbonReductionItemCellView = {
        let carbonReductionItem = carbonReductionItemInit()
        carbonReductionItem.setType(.bottle)
        return carbonReductionItem
    }()
    
    private lazy var batteryItemCellView:CarbonReductionItemCellView = {
        let carbonReductionItem = carbonReductionItemInit()
        carbonReductionItem.setType(.battery)
        return carbonReductionItem
    }()
    
    private lazy var papperCubItemCellView:CarbonReductionItemCellView = {
        let carbonReductionItem = carbonReductionItemInit()
        carbonReductionItem.setType(.papperCub)
        return carbonReductionItem
    }()
    
    private lazy var aluminumCanItemCellView:CarbonReductionItemCellView = {
        let carbonReductionItem = carbonReductionItemInit()
        carbonReductionItem.setType(.aluminumCan)
        return carbonReductionItem
    }()

    private  var selectedColor:UIColor?

    override func viewDidLoad() {
        super.viewDidLoad()
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func carbonReductionItemInit() -> CarbonReductionItemCellView {
        let carbonReductionItemCellView = CarbonReductionItemCellView()
        carbonReductionItemCellView.delegate = self
        return carbonReductionItemCellView
    }
    
    private func UIInit() {
        stackView.addArrangedSubview(bottleItemCellView)
        stackView.addArrangedSubview(batteryItemCellView)
        stackView.addArrangedSubview(papperCubItemCellView)
        stackView.addArrangedSubview(aluminumCanItemCellView)
    }
    
    @IBAction func confirm(_ sender:UIButton) {
//        guard let selectedColor = selectedColor else { return }
//        delegate?.chooseColor(selectedColor)
        self.dismiss(animated: true)
    }

    @IBAction func cancel(_ sender:UIButton) {
        delegate?.cancel()
        self.dismiss(animated: true)
    }

}


extension ChooseColorVC:CarbonReductionItemCellViewDelegate {
    func tapItem(_ color: UIColor) {
        delegate?.chooseColor(color)
    }
}
