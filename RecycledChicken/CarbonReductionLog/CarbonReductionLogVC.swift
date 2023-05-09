//
//  CarbonReductionLogVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/8.
//

import UIKit
import Charts
class CarbonReductionLogVC: CustomVC {
    
    @IBOutlet var chartView: PieChartView!
    
    @IBOutlet weak var recycleBtn:UIButton!
    
    let parties = ["PET", "BATT"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "減碳歷程"
        UIInit()
        setDefaultNavigationBackBtn()
    }

    private func UIInit() {

        view.backgroundColor = CommonColor.shared.color1
        chartView.delegate = self
        
        let l = chartView.legend
        l.horizontalAlignment = .right
        l.verticalAlignment = .top
        l.orientation = .vertical
        l.xEntrySpace = 7
        l.yEntrySpace = 0
        l.yOffset = 0
        chartView.entryLabelColor = .white
        chartView.entryLabelFont = .systemFont(ofSize: 12, weight: .light)
        setDataCount(2, range: 50)
        
        let paragraphStyle: NSMutableParagraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = .center
        let centerText: NSMutableAttributedString = NSMutableAttributedString(string: "400\nKgCO2")
        centerText.setAttributes([NSAttributedString.Key.font: UIFont(name:  "PingFang TC", size: 10.0)!, NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSMakeRange(0, centerText.length))
        
        centerText.setAttributes([NSAttributedString.Key.font: UIFont(name:  "HelveticaNeue-Bold", size: 20.0)!, NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSMakeRange(0, 3))
        
        self.chartView.centerAttributedText = centerText
        
        recycleBtn.layer.borderWidth = 1
        recycleBtn.layer.borderColor = #colorLiteral(red: 0.7647058964, green: 0.7647058964, blue: 0.7647058964, alpha: 1)
    }
    
    func setDataCount(_ count: Int, range: UInt32) {
        let entries = (0..<count).map { (i) -> PieChartDataEntry in
            return PieChartDataEntry(value: 50.0,
                                     label: parties[i % parties.count],
                                     icon: #imageLiteral(resourceName: "icon"))
        }
        
        let set = PieChartDataSet(entries: entries, label: "")
        set.drawIconsEnabled = false
        set.sliceSpace = 2
        
        
        set.colors = [CommonColor.shared.color1, CommonColor.shared.color3]
        
        let data = PieChartData(dataSet: set)
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        
        data.setValueFont(.systemFont(ofSize: 11, weight: .light))
        data.setValueTextColor(.black)
        
        chartView.data = data
        chartView.highlightPerTapEnabled = false
        chartView.highlightValues(nil)
    }
}

extension CarbonReductionLogVC:ChartViewDelegate{
    
}
