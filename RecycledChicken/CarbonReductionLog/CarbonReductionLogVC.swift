//
//  CarbonReductionLogVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/8.
//

import UIKit
import DropDown
import MKRingProgressView
import OverlayContainer
class CarbonReductionLogVC: CustomVC {
        
    @IBOutlet weak var recycleBtn:UIButton!
    
    @IBOutlet weak var recycleBtnWidth:NSLayoutConstraint!
    
    @IBOutlet weak var recycledRingInfoView:RecycledRingInfoView!
    
    @IBOutlet weak var dropDownView:DropDownView!
    
    @IBOutlet weak var bottleItemCellView:CarbonReductionItemCellView!
    
    @IBOutlet weak var batteryItemCellView:CarbonReductionItemCellView!
    
    @IBOutlet weak var papperCubItemCellView:CarbonReductionItemCellView!
    
    @IBOutlet weak var aluminumCanItemCellView:CarbonReductionItemCellView!
    
    @IBOutlet weak var publicTransportItemCellView:CarbonReductionItemCellView!
    
    @IBOutlet weak var colorFillScrollView:UIScrollView!
    
    @IBOutlet weak var colorFillTitleLabel:CustomLabel!
    
    @IBOutlet weak var bottomLineSpace:NSLayoutConstraint!
    
    @IBOutlet weak var convertValueLabel:UILabel!
        
    private var colorFillTypeOneView = ColorFillTypeOneView()
    
    private var colorFillTypeTwoView:ColorFillTypeTwoView = {
        let colorFillTypeTwoView = ColorFillTypeTwoView()
        colorFillTypeTwoView.userdefultKeyOfBackground = UserDefaultKey.shared.backgroundOfColorFillTypeTwoView
        return colorFillTypeTwoView
    }()
    
    private var colorFillTypeThreeView:ColorFillTypeThreeView = {
        let colorFillTypeThreeView = ColorFillTypeThreeView()
        colorFillTypeThreeView.userdefultKeyOfBackground = UserDefaultKey.shared.backgroundOfColorFillTypeThreeView
        return colorFillTypeThreeView
    }()
    
    private var colorFillTypeFourView:ColorFillTypeFourView = {
        let colorFillTypeFourView = ColorFillTypeFourView()
        colorFillTypeFourView.userdefultKeyOfBackground = UserDefaultKey.shared.backgroundOfColorFillTypeFourView
        return colorFillTypeFourView
    }()
    
    private lazy var colorFillViews = [colorFillTypeTwoView, colorFillTypeThreeView , colorFillTypeFourView, colorFillTypeOneView]
    
    private var maskView:UIView = {
        let v = UIView(frame: UIScreen.main.bounds)
        v.isHidden = true
        v.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7)
        return v
    }()
            
    private var colorFillScroViewIndex = 0
    {
        didSet {
            handeleChangeColorFillScroView()
        }
    }
            
    private var carbonReductionLogInfo:CarbonReductionLogInfo?
    
    private var currentPersonalRecyleAmountAndTargetInfo:PersonalRecycleAmountAndTargetInfo?
    
    private lazy var itemDropDown:DropDown = {
        let dropDown = DropDown()
        dropDown.textFont = dropDownView.sortLabel.font
        return dropDown
    }()
    
    private var batteryCount = 0
    
    private var bottleCount = 0
    
    private var colorlessBottle = 0
    
    private var colorlessBatteryCount = 0
        
//    private var cupCount = 0
    
    private var canCount = 0
    
//    private var publicTransportCount = 0
    
    private var chooseObject:ChooseObject?
    
    private var lastSelectedColor:UIColor?
    
    private var lastSelectedImage:UIImage?
    
    private var currentColorFillView:ColorFillView = .ColorFillTypeTwoView
    
    @UserDefault(UserDefaultKey.shared.colorBottleUseCount, defaultValue: 0) var colorBottleUseCount:Int
    
    @UserDefault(UserDefaultKey.shared.colorBatteryUseCount, defaultValue: 0) var colorBatteryUseCount:Int
    
    @UserDefault(UserDefaultKey.shared.colorPapperCubUseCount, defaultValue: 0) var colorPapperCubUseCount:Int
    
    @UserDefault(UserDefaultKey.shared.colorAluminumCanUseCount, defaultValue: 0) var colorAluminumCanUseCount:Int
    
    @UserDefault(UserDefaultKey.shared.colorFillTypeOneViewCo2Value, defaultValue: 0) var colorFillTypeOneViewCo2Value:Double
    
    @UserDefault(UserDefaultKey.shared.colorFillTypeTwoViewCo2Value, defaultValue: 0) var colorFillTypeTwoViewCo2Value:Double
    
    @UserDefault(UserDefaultKey.shared.colorFillTypeThreeViewCo2Value, defaultValue: 0) var colorFillTypeThreeViewCo2Value:Double
    
    @UserDefault(UserDefaultKey.shared.colorFillTypeFourViewCo2Value, defaultValue: 0) var colorFillTypeFourViewCo2Value:Double
        
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "carbonJourney".localized
        UIInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultNavigationBackBtn()
        getCarbonReductionRecords(completion: { [weak self] in
            guard let self = self, let carbonReductionLogInfo = self.carbonReductionLogInfo else { return }
            var itemNames:[String] = []
            carbonReductionLogInfo.personalRecycleAmountAndTarget?.forEach({ if let itemName = $0.itemName {
                itemNames.append(itemName)
                self.currentPersonalRecyleAmountAndTargetInfo = $0
            }})
            itemDropDown.dataSource.removeAll()
            itemDropDown.dataSource.append(contentsOf: itemNames)
            changeType()
            reloadItemCellViewValue()
            setConvertValueLabelText()
        })
    }
     
    private func getTotalCO2e() -> Double {
        guard let carbonReductionLogInfo = self.carbonReductionLogInfo else { return 0 }
        var allRecycled:Double = 0
        carbonReductionLogInfo.personalRecycleAmountAndTarget?.forEach({ info in
            let totalRecycled:Double = Double(info.totalRecycled ?? 0)
            let conversionRate:Double = info.conversionRate ?? 0
            let (resultValue, _ ) = getCO2(totalRecycled, conversionRate)
            allRecycled += Double(resultValue) ?? 0
        })
        return allRecycled
    }
    
    private func reloadItemCellViewValue() {
        if let numberOfColorsCounts = getNumberOfColorsCounts() {
            numberOfColorsCounts.forEach { numberOfColorsCount in
                let count = numberOfColorsCount.count
                switch numberOfColorsCount.recycleType {
                case .bottle:
                    bottleItemCellView.setCount(count)
                case .battery:
                    batteryItemCellView.setCount(count)
                case .papperCub:
                    papperCubItemCellView.setCount(count)
                case .aluminumCan:
                    aluminumCanItemCellView.setCount(count)
                }
            }
        }
    }
    
    private func getRecyceledSortInfo(_ itemName:String) -> RecyceledSort? {
        var result:RecyceledSort?
        switch itemName {
        case "寶特瓶":
            result = .bottle
        case "電池":
            result = .battery
        case "鋁罐":
            result = .aluminumCan
        case "紙杯":
            result = .papperCub
//        case "大眾運輸":
//            result = .publicTransport
        default :
            break
        }
        return result
    }
    
    private func changeType() {
        guard let personalRecyleAmountAndTargetInfo = currentPersonalRecyleAmountAndTargetInfo, let itemName = personalRecyleAmountAndTargetInfo.itemName, let recyceledSort = getRecyceledSortInfo(itemName), let totalRecycled = personalRecyleAmountAndTargetInfo.totalRecycled, let target = personalRecyleAmountAndTargetInfo.target, let conversionRate = personalRecyleAmountAndTargetInfo.conversionRate else { return }
        dropDownView.sortLabel.text = recyceledSort.getInfo().chineseName
        let (resultValue, resultUnit) = getCO2(Double(totalRecycled), conversionRate)
        recycledRingInfoView.setRecycledRingInfo(totalRecycled, recyceledSort.getInfo().recycleUnit, resultValue, resultUnit, Double(target), recyceledSort.getInfo().color)
    }
    
    private func getCO2(_ totalRecycled:Double, _ conversionRate:Double) -> (String, String) {
        let convetValue = totalRecycled * conversionRate
        let (resultValue, resultUnit) = convertWeight(convetValue)
        let resultValueStr = String(format: "%.1f", resultValue)
        return (resultValueStr, resultUnit.rawValue)
    }

    private func UIInit() {
        recycleBtn.layer.borderWidth = 1
        recycleBtn.layer.borderColor = #colorLiteral(red: 0.7647058964, green: 0.7647058964, blue: 0.7647058964, alpha: 1)
        bottleItemCellView.setType(.bottle)
        batteryItemCellView.setType(.battery)
        aluminumCanItemCellView.setType(.aluminumCan)
        papperCubItemCellView.setType(.papperCub)
//        publicTransportItemCellView.setType(.publicTransport)
        recycledRingInfoView.layer.shadowOffset = CGSize(width: 1, height: 1)
        recycledRingInfoView.layer.shadowOpacity = 0.2
        if let frame = colorFillScrollView.subviews.first?.subviews[0].frame {
            colorFillViews.forEach { v in
                v.frame = frame
                if v == colorFillTypeTwoView, let colorFillView = v as? ColorFillTypeTwoView {
                    colorFillView.delegate = self
                    colorFillScrollView.subviews.first?.subviews[0].addSubview(colorFillTypeTwoView)
                }
                if v == colorFillTypeThreeView, let colorFillView = v as? ColorFillTypeThreeView {
                    colorFillView.delegate = self
                    colorFillScrollView.subviews.first?.subviews[1].addSubview(colorFillTypeThreeView)
                }
                if v == colorFillTypeFourView, let colorFillView = v as? ColorFillTypeFourView {
                    colorFillView.delegate = self
                    colorFillScrollView.subviews.first?.subviews[2].addSubview(colorFillTypeFourView)
                }
                if v == colorFillTypeOneView, let colorFillView = v as? ColorFillTypeOneView {
                    colorFillView.delegate = self
                    colorFillScrollView.subviews.first?.subviews[3].addSubview(colorFillTypeOneView)
                }
            }
        }
        itemDropDown.anchorView = dropDownView
        itemDropDown.bottomOffset = CGPoint(x: 0, y: dropDownView.bounds.height)
        itemDropDown.selectionAction = { [weak self] (index, item) in
            guard let self = self, let carbonReductionLogInfo = carbonReductionLogInfo else { return }
            currentPersonalRecyleAmountAndTargetInfo = nil
            currentPersonalRecyleAmountAndTargetInfo = carbonReductionLogInfo.personalRecycleAmountAndTarget?.first(where: { personalRecyleAmountAndTargetInfo in
                if let itemName = personalRecyleAmountAndTargetInfo.itemName {
                    return itemName == item
                }
                return false
            })
            changeType()
        }
        
        if getLanguage() == .english {
            recycleBtnWidth.constant = 200
            bottomLineSpace.constant = -5
        }
        keyWindow?.addSubview(maskView)
    }
    
    private func getCarbonReductionRecords(completion: @escaping () -> Void) {
        NetworkManager.shared.getJSONBody(urlString: APIUrl.domainName + APIUrl.carbonReductionRecords, authorizationToken: CommonKey.shared.authToken) { data, statusCode, errorMSG in
            guard let data = data,statusCode == 200 else {
                showAlert(VC: self, title: "error".localized, message: errorMSG)
                return
            }
            if let carbonReductionLogInfo = try? JSONDecoder().decode(CarbonReductionLogInfo.self, from: data) {
                self.carbonReductionLogInfo = nil
                self.carbonReductionLogInfo = carbonReductionLogInfo
                completion()
            }
        }
    }
    
    @IBAction func goBuenopartners(_ sender:UIButton) {
        if let url = URL(string:APIUrl.buenopartners) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func goToRecycleLog(_ sender:UIButton) {
        if let navigationController = self.navigationController, let VC = UIStoryboard(name: "RecycleLog", bundle: Bundle.main).instantiateViewController(identifier: "RecycleLog") as? RecycleLogVC {
            pushVC(targetVC: VC, navigation: navigationController)
        }
    }
    
    private func handeleChangeColorFillScroView() {
        colorFillScrollView.contentOffset = CGPoint(x: Int(colorFillScrollView.frame.width) * colorFillScroViewIndex, y: 0)
        colorFillTitleLabel.text = "\("restorationOfCoopland".localized)\(colorFillScroViewIndex + 1)"
    }
    
    @IBAction func scrollViewNext(_ sender:UIButton) {
        guard let maxCount = colorFillScrollView.subviews.first?.subviews.count, maxCount > 0, colorFillScroViewIndex + 1 < maxCount else { return }
        colorFillScroViewIndex += 1
        setConvertValueLabelText()
    }
    
    @IBAction func scrollViewLast(_ sender:UIButton) {
        guard colorFillScroViewIndex > 0 else { return }
        colorFillScroViewIndex -= 1
        setConvertValueLabelText()
    }
    
    @IBAction func changeItem(_ tap: UITapGestureRecognizer) {
        itemDropDown.show()
    }
    
    private func startViewHanle(_ v:UIView?, _ imageView:UIImageView?, _ userdefultKey: String) {
        chooseObject = nil
        lastSelectedColor = nil
        lastSelectedImage = nil
        if let v = v {
            chooseObject = ChooseObject(backgroundView: v, userdefultKey: userdefultKey)
            lastSelectedColor = v.backgroundColor
        }
        if let imageView = imageView {
            chooseObject = ChooseObject(imageView: imageView, userdefultKey: userdefultKey)
            lastSelectedImage = imageView.image
        }
        maskView.isHidden = false
    }
    
    private func finishViewHandle() {
        maskView.isHidden = true
    }
    
    private func getNumberOfColorsCounts() -> [NumberOfColorsCount]? {
        guard let carbonReductionLogInfo = carbonReductionLogInfo, let personalRecycleAmountAndTargets = carbonReductionLogInfo.personalRecycleAmountAndTarget else { return nil }
        var numberOfColorsCounts:[NumberOfColorsCount] = []
        personalRecycleAmountAndTargets.forEach { info in
            guard let totalRecycled = info.totalRecycled, totalRecycled > 0, let itemName = info.itemName, let recyceledSort = getRecyceledSortInfo(itemName) else { return }
            var total = 0
            let colorCount = totalRecycled / 20
            switch recyceledSort {
            case .bottle:
                total = colorCount - colorBottleUseCount
            case .battery:
                total = colorCount - colorBatteryUseCount
            case .papperCub:
                total = colorCount - colorPapperCubUseCount
            case .aluminumCan:
                total = colorCount - colorAluminumCanUseCount
            }
            let numberOfColorsCount = NumberOfColorsCount(recycleType: recyceledSort, count: total)
            numberOfColorsCounts.append(numberOfColorsCount)
        }
        return numberOfColorsCounts
    }
    
    private func goChooseColorVC() {
        guard let numberOfColorsCounts = getNumberOfColorsCounts() else { return }
        if let VC = UIStoryboard(name: "ChooseColor", bundle: Bundle.main).instantiateViewController(identifier: "ChooseColor") as? ChooseColorVC {
            VC.delegate = self
            VC.setNumberOfColorsCounts(numberOfColorsCounts)
            let container = OverlayContainerViewController()
            container.viewControllers = [VC]
            container.delegate = self
            container.moveOverlay(toNotchAt: Notch.minimum.rawValue, animated: false)
            container.modalPresentationStyle = .custom
            present(container, animated: true, completion: nil)
        }
    }
    
    private func getConvertValue(_ useRecyceledSort:RecyceledSort) {
        guard let carbonReductionLogInfo = self.carbonReductionLogInfo, let recycleInfo = carbonReductionLogInfo.personalRecycleAmountAndTarget?.first(where: {$0.itemName == useRecyceledSort.getInfo().chineseName}) else { return }
        let colorRecycledValue = recycleInfo.getColorRecycledValue()
        let resultValue = colorRecycledValue / 1000
        switch currentColorFillView {
        case .ColorFillTypeOneView:
            colorFillTypeOneViewCo2Value += Double(resultValue)
        case .ColorFillTypeTwoView:
            colorFillTypeTwoViewCo2Value += Double(resultValue)
        case .ColorFillTypeThreeView:
            colorFillTypeThreeViewCo2Value += Double(resultValue)
        case .ColorFillTypeFourView:
            colorFillTypeFourViewCo2Value += Double(resultValue)
        }
    }
    
    private func setConvertValueLabelText() {
        var resultValue:Double = 0
        switch colorFillScroViewIndex {
            case 0:
                resultValue = colorFillTypeTwoViewCo2Value
            case 1:
                resultValue = colorFillTypeThreeViewCo2Value
            case 2:
                resultValue = colorFillTypeFourViewCo2Value
            case 3:
                resultValue = colorFillTypeOneViewCo2Value
            default:
                break
        }
        convertValueLabel.text = String(resultValue)
    }
    
}

extension CarbonReductionLogVC: ChooseColorVCDelete {
    
    func comfirm(_ useRecyceledSort: RecyceledSort) {
        finishViewHandle()
        guard let chooseObject = chooseObject else { return }
        UserDefaults().setColor(useRecyceledSort.getInfo().color, forKey: chooseObject.userdefultKey)
        switch useRecyceledSort {
        case .bottle:
            colorBottleUseCount += 1
        case .battery:
            colorBatteryUseCount += 1
        case .papperCub:
            colorPapperCubUseCount += 1
        case .aluminumCan:
            colorAluminumCanUseCount += 1
        }
        reloadItemCellViewValue()
        getConvertValue(useRecyceledSort)
        setConvertValueLabelText()
    }
    
    func cancel() {
        finishViewHandle()
        guard let chooseObject = chooseObject else { return }
        if let imageView = chooseObject.imageView {
            imageView.image = lastSelectedImage
        }
        if let backgroundView = chooseObject.backgroundView {
            backgroundView.backgroundColor = lastSelectedColor
        }
    }
    
    func chooseColor(_ color: UIColor) {
        guard let chooseObject = chooseObject else { return }
        if let imageView = chooseObject.imageView {
            imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
            imageView.tintColor = color
        }
        if let backgroundView = chooseObject.backgroundView {
            backgroundView.backgroundColor = color
        }
    }
    
}

extension CarbonReductionLogVC: ColorFillTypeDelegate {
    
    func tapImage(_ imageView: UIImageView, userdefultKey: String, colorFillView: ColorFillView) {
        currentColorFillView = colorFillView
        startViewHanle(nil, imageView, userdefultKey)
        goChooseColorVC()
    }
    
    func tapBackground(_ backgroundView: UIView, userdefultKey: String, colorFillView: ColorFillView) {
        currentColorFillView = colorFillView
        startViewHanle(backgroundView, nil, userdefultKey)
        goChooseColorVC()
    }
    
}

extension CarbonReductionLogVC: OverlayTransitioningDelegate, OverlayContainerViewControllerDelegate, OverlayContainerSheetPresentationControllerDelegate {
    
    func overlayContainerViewController(_ containerViewController: OverlayContainer.OverlayContainerViewController, heightForNotchAt index: Int, availableSpace: CGFloat) -> CGFloat {
        150
//        switch Notch.allCases[index] {
//        case .minimum:
//            return 150
//        case .medium:
//            return 300
//        case .maximum:
//            return availableSpace - 200
//        }
    }
    
    func numberOfNotches(in containerViewController: OverlayContainerViewController) -> Int {
//        Notch.allCases.count
        1
    }
    
}
