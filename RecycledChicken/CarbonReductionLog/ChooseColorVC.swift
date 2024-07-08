//
//  ChooseColorVC.swift
//  RecycledChicken
//
//  Created by ClaudLin on 2024/7/3.
//

import UIKit

protocol ChooseColorVCDelete {
    func comfirm(_ color:UIColor )
    func chooseColor(_ color:UIColor )
    func cancel()
}

class ChooseColorVC: UIViewController {
    
    var delegate:ChooseColorVCDelete?
    
    @IBOutlet weak var stackView:UIStackView!
    
    private var numberOfColorsCounts:[NumberOfColorsCount] = []

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
        addItemCellView()
    }
    
    private func addItemCellView() {
        guard numberOfColorsCounts.count > 0 else { return }
        stackView.removeFullyAllArrangedSubviews()
        numberOfColorsCounts.forEach { numberOfColorsCount in
            let carbonReductionItem = carbonReductionItemInit()
            carbonReductionItem.setType(numberOfColorsCount.recycleType)
            carbonReductionItem.setCount(numberOfColorsCount.count)
            stackView.addArrangedSubview(carbonReductionItem)
        }
    }
    
    func setNumberOfColorsCount(_ numberOfColorsCounts:[NumberOfColorsCount]) {
        self.numberOfColorsCounts.removeAll()
        self.numberOfColorsCounts.append(contentsOf: numberOfColorsCounts)
    }
    
    @IBAction func confirm(_ sender:UIButton) {
        guard let selectedColor = selectedColor else {
            self.dismiss(animated: true)
            return
        }
        delegate?.comfirm(selectedColor)
        self.dismiss(animated: true)
    }

    @IBAction func cancel(_ sender:UIButton) {
        delegate?.cancel()
        self.dismiss(animated: true)
    }

}

extension ChooseColorVC:CarbonReductionItemCellViewDelegate {
    func tapItem(_ color: UIColor) {
        selectedColor = nil
        selectedColor = color
        delegate?.chooseColor(color)
    }
}
