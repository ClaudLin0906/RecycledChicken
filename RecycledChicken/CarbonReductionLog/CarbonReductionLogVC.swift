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

protocol ColorFillTypeDelegate {
    func tapImage(_ imageView: UIImageView, userdefultKey: String, colorFillView: ColorFillView)
    func tapBackground(_ backgroundView: UIView, userdefultKey: String, colorFillView: ColorFillView)
}

enum Notch: Int, CaseIterable {
    case minimum, medium, maximum
}

enum ColorFillView {
    case ColorFillTypeOneView
    case ColorFillTypeTwoView
    case ColorFillTypeThreeView
    case ColorFillTypeFourView
}

private struct ChooseObject {
    var imageView: UIImageView?
    var backgroundView: UIView?
    var userdefultKey: String
}

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
            handleChangeColorFillScrollView()
        }
    }
            
    private var carbonReductionLogInfo:CarbonReductionLogInfo?
    
    private var currentPersonalRecyleAmountAndTargetInfo:PersonalRecycleAmountAndTargetInfo?
    
    private lazy var itemDropDown:DropDown = {
        let dropDown = DropDown()
        dropDown.textFont = dropDownView.sortLabel.font
        return dropDown
    }()
    
    private lazy var itemCellViewMap: [RecycleItem: CarbonReductionItemCellView] = [
        .bottle: bottleItemCellView,
        .battery: batteryItemCellView,
        .papperCub: papperCubItemCellView,
        .aluminumCan: aluminumCanItemCellView
    ]

    private var chooseObject: ChooseObject?
    
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
            guard let self = self, let items = self.carbonReductionLogInfo?.personalRecycleAmountAndTarget else { return }
            itemDropDown.dataSource = items.compactMap { $0.itemName }
            currentPersonalRecyleAmountAndTargetInfo = items.last
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
        getNumberOfColorsCounts()?.forEach { numberOfColorsCount in
            itemCellViewMap[numberOfColorsCount.recycleType]?.setCount(numberOfColorsCount.count)
        }
    }
    
    private func changeType() {
        guard let personalRecyleAmountAndTargetInfo = currentPersonalRecyleAmountAndTargetInfo,
              let itemName = personalRecyleAmountAndTargetInfo.itemName,
              let recycleItem = RecycleItem.from(apiName: itemName),
              let totalRecycled = personalRecyleAmountAndTargetInfo.totalRecycled,
              let target = personalRecyleAmountAndTargetInfo.target,
              let conversionRate = personalRecyleAmountAndTargetInfo.conversionRate else { return }
        dropDownView.sortLabel.text = recycleItem.chineseName
        let (resultValue, resultUnit) = getCO2(Double(totalRecycled), conversionRate)
        recycledRingInfoView.setRecycledRingInfo(totalRecycled, recycleItem.recycleUnit, resultValue, resultUnit, Double(target), recycleItem.color)
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
        recycledRingInfoView.layer.shadowOffset = CGSize(width: 1, height: 1)
        recycledRingInfoView.layer.shadowOpacity = 0.2
        setupColorFillViews()
        itemDropDown.anchorView = dropDownView
        itemDropDown.bottomOffset = CGPoint(x: 0, y: dropDownView.bounds.height)
        itemDropDown.selectionAction = { [weak self] (index, item) in
            guard let self = self, let carbonReductionLogInfo = carbonReductionLogInfo else { return }
            currentPersonalRecyleAmountAndTargetInfo = carbonReductionLogInfo.personalRecycleAmountAndTarget?.first { $0.itemName == item }
            changeType()
        }
        if getLanguage() == .english {
            recycleBtnWidth.constant = 200
            bottomLineSpace.constant = -5
        }
        keyWindow?.addSubview(maskView)
    }

    private func setupColorFillViews() {
        guard let contentView = colorFillScrollView.subviews.first,
              let frame = contentView.subviews.first?.frame else { return }
        colorFillViews.forEach { $0.frame = frame }
        colorFillTypeTwoView.delegate = self
        contentView.subviews[0].addSubview(colorFillTypeTwoView)
        colorFillTypeThreeView.delegate = self
        contentView.subviews[1].addSubview(colorFillTypeThreeView)
        colorFillTypeFourView.delegate = self
        contentView.subviews[2].addSubview(colorFillTypeFourView)
        colorFillTypeOneView.delegate = self
        let container = contentView.subviews[3]
        container.addSubview(colorFillTypeOneView)
        colorFillTypeOneView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            colorFillTypeOneView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            colorFillTypeOneView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            colorFillTypeOneView.widthAnchor.constraint(equalTo: container.heightAnchor),
            colorFillTypeOneView.heightAnchor.constraint(equalTo: container.heightAnchor)
        ])
    }
    
    private func getCarbonReductionRecords(completion: @escaping () -> Void) {
        NetworkManager.shared.get(url: APIUrl.domainName + APIUrl.carbonReductionRecords,
                                   authorizationToken: CommonKey.shared.authToken,
                                   responseType: CarbonReductionLogInfo.self) { [weak self] result in
            switch result {
            case .success(let carbonReductionLogInfo):
                self?.carbonReductionLogInfo = nil
                self?.carbonReductionLogInfo = carbonReductionLogInfo
                completion()
            case .failure(let error):
                DispatchQueue.main.async {
                    showAlert(VC: self, title: "error".localized, message: error.localizedDescription)
                }
            }
        }
    }
    
    @IBAction func goBuenopartners(_ sender:UIButton) {
        if let url = URL(string:RedirectURL.buenopartners) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func goToRecycleLog(_ sender:UIButton) {
        if let navigationController = self.navigationController, let VC = UIStoryboard(name: "RecycleLog", bundle: Bundle.main).instantiateViewController(identifier: "RecycleLog") as? RecycleLogVC {
            pushVC(targetVC: VC, navigation: navigationController)
        }
    }
    
    private func handleChangeColorFillScrollView() {
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
    
    private func startViewHandle(_ v: UIView?, _ imageView: UIImageView?, _ userdefultKey: String) {
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
        var numberOfColorsCounts: [NumberOfColorsCount] = []
        personalRecycleAmountAndTargets.forEach { info in
            guard let totalRecycled = info.totalRecycled, totalRecycled > 0, let itemName = info.itemName, let recycleItem = RecycleItem.from(apiName: itemName) else { return }
            let colorCount = totalRecycled / 20
            let useCount: Int
            switch recycleItem {
            case .bottle:      useCount = colorBottleUseCount
            case .battery:     useCount = colorBatteryUseCount
            case .papperCub:   useCount = colorPapperCubUseCount
            case .aluminumCan: useCount = colorAluminumCanUseCount
            default:           useCount = 0
            }
            let numberOfColorsCount = NumberOfColorsCount(recycleType: recycleItem, count: colorCount - useCount)
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
    
    private func getConvertValue(_ useRecyceledSort: RecycleItem) {
        let resultValue = useRecyceledSort.colorRecycledValue / 1000
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
        let co2Values = [colorFillTypeTwoViewCo2Value, colorFillTypeThreeViewCo2Value, colorFillTypeFourViewCo2Value, colorFillTypeOneViewCo2Value]
        guard colorFillScroViewIndex < co2Values.count else { return }
        convertValueLabel.text = String(co2Values[colorFillScroViewIndex])
    }
    
    @IBAction func showColoringTutorialVideo(_ sender:UIButton) {
        let coloringTutorialVideoView = ColoringTutorialVideoView(frame: UIScreen.main.bounds)
        keyWindow?.addSubview(coloringTutorialVideoView)
    }
    
}

extension CarbonReductionLogVC: ChooseColorVCDelete {
    
    func comfirm(_ useRecyceledSort: RecycleItem) {
        finishViewHandle()
        guard let chooseObject = chooseObject else { return }
        UserDefaults().setColor(useRecyceledSort.color, forKey: chooseObject.userdefultKey)
        switch useRecyceledSort {
        case .bottle:
            colorBottleUseCount += 1
        case .battery:
            colorBatteryUseCount += 1
        case .papperCub:
            colorPapperCubUseCount += 1
        case .aluminumCan:
            colorAluminumCanUseCount += 1
        default:
            break
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
        startViewHandle(nil, imageView, userdefultKey)
        goChooseColorVC()
    }
    
    func tapBackground(_ backgroundView: UIView, userdefultKey: String, colorFillView: ColorFillView) {
        currentColorFillView = colorFillView
        startViewHandle(backgroundView, nil, userdefultKey)
        goChooseColorVC()
    }
    
}

extension CarbonReductionLogVC: OverlayTransitioningDelegate, OverlayContainerViewControllerDelegate, OverlayContainerSheetPresentationControllerDelegate {
    
    func overlayContainerViewController(_ containerViewController: OverlayContainer.OverlayContainerViewController, heightForNotchAt index: Int, availableSpace: CGFloat) -> CGFloat {
        150
    }
    
    func numberOfNotches(in containerViewController: OverlayContainerViewController) -> Int {
        1
    }
    
}
