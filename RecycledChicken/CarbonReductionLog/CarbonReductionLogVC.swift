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
    
    @IBOutlet weak var convertVauleLabel:UILabel!
        
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
    
    private lazy var colorFillTypeViews = [colorFillTypeTwoView, colorFillTypeOneView, colorFillTypeThreeView, colorFillTypeFourView]
        
    private var colorFillScroViewIndex = 0
    {
        didSet {
            handeleChangeColorFillScroView()
        }
    }
            
    private var recyceledSortInfos:[RecyceledSortInfo] = {
        var arr:[RecyceledSortInfo] = []
        for i in RecyceledSort.allCases {
            arr.append(i.getInfo())
        }
        return arr
    }()
    
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
    
    private var colorlessBottleCount = 0
        
//    private var cupCount = 0
    
    private var canCount = 0
    
//    private var publicTransportCount = 0
    
    private var chooseObject:ChooseObject?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "carbonJourney".localized
        UIInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultNavigationBackBtn()
        getRecycleLogData()
        getCarbonReductionRecords(completion: { [self] in
            guard let carbonReductionLogInfo = self.carbonReductionLogInfo else { return }
            var itemNames:[String] = []
            carbonReductionLogInfo.personalRecycleAmountAndTarget?.forEach({ if let itemName = $0.itemName {
                itemNames.append(itemName)
                currentPersonalRecyleAmountAndTargetInfo = $0
            }})
            itemDropDown.dataSource.removeAll()
            itemDropDown.dataSource.append(contentsOf: itemNames)
            changeType()
        })
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
        guard let personalRecyleAmountAndTargetInfo = currentPersonalRecyleAmountAndTargetInfo, let itemName = personalRecyleAmountAndTargetInfo.itemName, let recyceledSort = getRecyceledSortInfo(itemName) else { return }
        dropDownView.sortLabel.text = recyceledSort.getInfo().chineseName
        recycledRingInfoView.setRecycledRingInfo(recyceledSort, personalRecyleAmountAndTargetInfo: personalRecyleAmountAndTargetInfo)
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
        itemDropDown.selectionAction = { [self] (index, item) in
            guard let carbonReductionLogInfo = carbonReductionLogInfo else { return }
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
        if let url = URL(string: "https://www.buenopartners.com.tw/formula") {
            UIApplication.shared.open(url)
        }
    }
    
    private func getRecycleLogData() {
        guard let dateLastYear = dateLastYearSameDay() else { return }
        let startTime = dateFromStringISO8601(date: dateLastYear)
        let endTime = dateFromStringISO8601(date: Date())
        getRecords(nil, startTime, endTime) { statusCode, errorMSG, useRecordInfos, battery, bottle, colorledBottle, colorlessBottle, can, cup in
            guard let statusCode = statusCode, statusCode == 200 else {
                showAlert(VC: self, title: "error".localized)
                return
            }
            DispatchQueue.main.async { [self] in
                batteryCount = battery ?? 0
                var totalBottleCount = 0
                if let bottle = bottle {
                    totalBottleCount += bottle
                }
                if let colorledBottle = colorledBottle {
                    totalBottleCount += colorledBottle
                }
                if let colorlessBottle = colorlessBottle {
                    totalBottleCount += colorlessBottle
                }
                bottleCount = totalBottleCount
                canCount = can ?? 0
//                cupCount = can ?? 0
                bottleItemCellView.setCount(bottleCount)
                batteryItemCellView.setCount(batteryCount)
//                papperCubItemCellView.setCount(cupCount)
                aluminumCanItemCellView.setCount(canCount)
//                publicTransportItemCellView.setCount(publicTransportCount)
            }
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
    }
    
    @IBAction func scrollViewLast(_ sender:UIButton) {
        guard colorFillScroViewIndex > 0 else { return }
        colorFillScroViewIndex -= 1
    }
    
    @IBAction func changeItem(_ tap: UITapGestureRecognizer) {
        itemDropDown.show()
    }
    
    private func startViewHanle(_ v:UIView?, _ imageView:UIImageView?, _ userdefultKey: String) {
        chooseObject = nil
        if let v = v {
            chooseObject = ChooseObject(backgroundView: v, userdefultKey: userdefultKey)
        }
        if let imageView = imageView {
            chooseObject = ChooseObject(imageView: imageView, userdefultKey: userdefultKey)
        }
        maskView.isHidden = false
    }
    
    private func finishViewHandle() {
        maskView.isHidden = true
    }
    
    private func getNumberOfColorsUseds() -> [NumberOfColorsUsed]? {
        guard let carbonReductionLogInfo = carbonReductionLogInfo, let personalRecycleAmountAndTargets = carbonReductionLogInfo.personalRecycleAmountAndTarget else { return nil }
        var numberOfColorsUseds:[NumberOfColorsUsed] = []
        personalRecycleAmountAndTargets.forEach { info in
            guard let totalRecycled = info.totalRecycled, totalRecycled > 0, let itemName = info.itemName, let recyceledSort = getRecyceledSortInfo(itemName) else { return }
            let numberOfColorsUsed = NumberOfColorsUsed(recycleType: recyceledSort, count: totalRecycled)
            numberOfColorsUseds.append(numberOfColorsUsed)
        }
        return numberOfColorsUseds
    }
    
    private func goChooseColorVC() {
        guard let numberOfColorsUseds = getNumberOfColorsUseds() else { return }
        if let VC = UIStoryboard(name: "ChooseColor", bundle: Bundle.main).instantiateViewController(identifier: "ChooseColor") as? ChooseColorVC {
            VC.delegate = self
            VC.setNumberOfColorsUsed(numberOfColorsUseds)
            let container = OverlayContainerViewController()
            container.viewControllers = [VC]
            container.delegate = self
            container.moveOverlay(toNotchAt: Notch.minimum.rawValue, animated: false)
            container.modalPresentationStyle = .custom
            present(container, animated: true, completion: nil)
        }
    }
}

extension CarbonReductionLogVC: ChooseColorVCDelete {
    
    func comfirm(_ color: UIColor) {
        finishViewHandle()
        guard let chooseObject = chooseObject else { return }
        UserDefaults().setColor(color, forKey: chooseObject.userdefultKey)
    }
    
    func cancel() {
        finishViewHandle()
    }
    
    func chooseColor(_ color: UIColor) {
        guard let chooseObject = chooseObject else { return }
        UserDefaults().setColor(color, forKey: chooseObject.userdefultKey)
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
    
    func tapImage(_ imageView: UIImageView, userdefultKey: String) {
        startViewHanle(nil, imageView, userdefultKey)
        goChooseColorVC()
    }
    
    func tapBackground(_ backgroundView: UIView, userdefultKey: String) {
        startViewHanle(backgroundView, nil, userdefultKey)
        goChooseColorVC()
    }
    
}

extension CarbonReductionLogVC: OverlayTransitioningDelegate, OverlayContainerViewControllerDelegate, OverlayContainerSheetPresentationControllerDelegate {
    
    func overlayContainerViewController(_ containerViewController: OverlayContainer.OverlayContainerViewController, heightForNotchAt index: Int, availableSpace: CGFloat) -> CGFloat {
        switch Notch.allCases[index] {
        case .minimum:
            return 150
        case .medium:
            return 300
        case .maximum:
            return availableSpace - 200
        }
    }
    
    func numberOfNotches(in containerViewController: OverlayContainerViewController) -> Int {
        Notch.allCases.count
    }
    
}
