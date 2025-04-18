//
//  ChooseColorVC.swift
//  RecycledChicken
//
//  Created by ClaudLin on 2024/7/3.
//

import UIKit

protocol ChooseColorVCDelete {
    func comfirm( _ useRecyceledSort:RecyceledSort )
    func chooseColor(_ color:UIColor )
    func cancel()
}

class ChooseColorVC: UIViewController {
    
    var delegate:ChooseColorVCDelete?
    
    @IBOutlet weak var stackView:UIStackView!
    
    @IBOutlet weak var alertLabel:CustomLabel!
    
    private var numberOfColorsCounts:[NumberOfColorsCount] = []
    
    private var selectedRecyceledSort:RecyceledSort?

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
        guard numberOfColorsCounts.count > 0 else {
            alertLabel.isHidden = false
            return
        }
        alertLabel.isHidden = true
        stackView.removeFullyAllArrangedSubviews()
        numberOfColorsCounts.forEach { numberOfColorsCount in
            let carbonReductionItem = carbonReductionItemInit()
            carbonReductionItem.setType(numberOfColorsCount.recycleType)
            carbonReductionItem.setCount(numberOfColorsCount.count)
            stackView.addArrangedSubview(carbonReductionItem)
        }
    }
    
    func setNumberOfColorsCounts(_ numberOfColorsCounts:[NumberOfColorsCount]) {
        self.numberOfColorsCounts.removeAll()
        let biggerZeroNumberOfColor = numberOfColorsCounts.filter({$0.count > 0})
        self.numberOfColorsCounts.append(contentsOf: biggerZeroNumberOfColor)
    }
    
    @IBAction func confirm(_ sender:UIButton) {
        guard let selectedRecyceledSort = selectedRecyceledSort else {
            delegate?.cancel()
            self.dismiss(animated: true)
            return
        }
        delegate?.comfirm(selectedRecyceledSort)
        self.dismiss(animated: true)
    }

    @IBAction func cancel(_ sender:UIButton) {
        delegate?.cancel()
        self.dismiss(animated: true)
    }

}

extension ChooseColorVC:CarbonReductionItemCellViewDelegate {
    func tapItem(_ useRecyceledSort: RecyceledSort) {
        selectedRecyceledSort = nil
        selectedRecyceledSort = useRecyceledSort
        delegate?.chooseColor(useRecyceledSort.getInfo().color)
    }
}
