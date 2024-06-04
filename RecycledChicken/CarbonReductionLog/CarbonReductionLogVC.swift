//
//  CarbonReductionLogVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/8.
//

import UIKit
import DropDown
import MKRingProgressView

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
    
    private  var selectedColor:UIColor = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
    
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
    
//    private var colorlessBottleCount = 0
    
    private var papperCubCount = 0
    
    private var canCount = 0
    
    private var publicTransportCount = 0
        
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
            itemDropDown.dataSource.append(contentsOf: itemNames)
            dropDownView.sortLabel.text = itemNames[0]
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
        case "大眾運輸":
            result = .publicTransport
        default :
            break
        }
        return result
    }
    
    private func changeType() {
        guard let personalRecyleAmountAndTargetInfo = currentPersonalRecyleAmountAndTargetInfo, let itemName = personalRecyleAmountAndTargetInfo.itemName, let recyceledSort = getRecyceledSortInfo(itemName) else { return }
        var count = 0
        switch recyceledSort {
        case .bottle:
            count = bottleCount
        case .battery:
            count = batteryCount
        case .papperCub:
            count = papperCubCount
        case .aluminumCan:
            count = canCount
        case .publicTransport:
            count = publicTransportCount
        }
        recycledRingInfoView.setRecycledRingInfo(recyceledSort, personalRecyleAmountAndTargetInfo: personalRecyleAmountAndTargetInfo, count)
    }

    private func UIInit() {
        dropDownView.sortLabel.text = recyceledSortInfos.first?.chineseName
        recycleBtn.layer.borderWidth = 1
        recycleBtn.layer.borderColor = #colorLiteral(red: 0.7647058964, green: 0.7647058964, blue: 0.7647058964, alpha: 1)
        bottleItemCellView.setType(.bottle)
        batteryItemCellView.setType(.battery)
        papperCubItemCellView.setType(.papperCub)
        aluminumCanItemCellView.setType(.aluminumCan)
        publicTransportItemCellView.setType(.publicTransport)
        recycledRingInfoView.layer.shadowOffset = CGSize(width: 1, height: 1)
        recycledRingInfoView.layer.shadowOpacity = 0.2
        if let frame = colorFillScrollView.subviews.first?.subviews[0].frame {
            colorFillTypeTwoView.frame = frame
            colorFillTypeOneView.frame = frame
            colorFillTypeThreeView.frame = frame
            colorFillTypeFourView.frame = frame
            colorFillTypeOneView.delegate = self
            colorFillTypeTwoView.delegate = self
            colorFillTypeThreeView.delegate = self
            colorFillTypeFourView.delegate = self
            colorFillScrollView.subviews.first?.subviews[0].addSubview(colorFillTypeTwoView)
            colorFillScrollView.subviews.first?.subviews[1].addSubview(colorFillTypeThreeView)
            colorFillScrollView.subviews.first?.subviews[2].addSubview(colorFillTypeFourView)
            colorFillScrollView.subviews.first?.subviews[3].addSubview(colorFillTypeOneView)
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
            setValueOfDropDown()
            changeType()
        }
        
        if getLanguage() == .english {
            recycleBtnWidth.constant = 200
            bottomLineSpace.constant = -5
        }
//        "Congratulations!\n恭喜你電池回收量\n超額完成!"
        // Do any additional setup after loading the view.
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
    
    private func setValueOfDropDown() {
        guard let currentPersonalRecyleAmountAndTargetInfo = currentPersonalRecyleAmountAndTargetInfo else { return }
        dropDownView.sortLabel.text = currentPersonalRecyleAmountAndTargetInfo.itemName ?? ""
    }
    
    @IBAction func goBuenopartners(_ sender:UIButton) {
        if let url = URL(string: "https://www.buenopartners.com.tw/formula") {
            UIApplication.shared.open(url)
        }
    }
    
    private func getRecycleLogData(){
        guard let dateLastYear = dateLastYearSameDay() else { return }
        let startTime = dateFromStringISO8601(date: dateLastYear)
        let endTime = dateFromStringISO8601(date: Date())
        let urlStr = APIUrl.domainName + APIUrl.records + "?startTime=\(startTime)&endTime=\(endTime)"
        NetworkManager.shared.getJSONBody(urlString: urlStr, authorizationToken: CommonKey.shared.authToken) { [self] (data, statusCode, errorMSG) in
            guard statusCode == 200 else {
                showAlert(VC: self, title: "error".localized, message: errorMSG)
                return
            }
            batteryCount = 0
            bottleCount = 0
//            colorlessBottleCount = 0
            canCount = 0
            if let data = data, let useRecordInfos = try? JSONDecoder().decode([UseRecordInfo].self, from: data) {
                useRecordInfos.forEach { useRecordInfo in
                    if let recycleDetails = useRecordInfo.recycleDetails {
                        if let battery = recycleDetails.battery {
                            batteryCount += battery
                        }
                        if let bottle = recycleDetails.bottle {
                            bottleCount += bottle
                        }
                        if let colorlessBottle = recycleDetails.colorlessBottle {
                            bottleCount += colorlessBottle
                        }
                        if let can = recycleDetails.can {
                            canCount += can
                        }
                    }
                }
                DispatchQueue.main.async { [self] in
                    bottleItemCellView.setCount(bottleCount)
                    batteryItemCellView.setCount(batteryCount)
                    papperCubItemCellView.setCount(papperCubCount)
                    aluminumCanItemCellView.setCount(canCount)
                    publicTransportItemCellView.setCount(publicTransportCount)
//                    UIView.animate(withDuration: 0.5) { [self] in

//                        let batteryprogress = Double(batteryInt)/1200
//                        let bottleprogress = Double(bottleInt)/1200
//                        progressGroup.ring1.progress = batteryprogress
//                        progressGroup.ring2.progress = bottleprogress
//                        if batteryprogress >= 1 && bottleprogress >= 1{
//                            isHiddenCongratulations(false)
//                        }
//                    }
                }
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
}

extension CarbonReductionLogVC: ColorFillTypeDelegate {
    
    func tapImage(_ imageView: UIImageView, userdefultKey: String) {
        UserDefaults().setColor(selectedColor, forKey: userdefultKey)
        imageView.image = imageView.image?.withTintColor(selectedColor, renderingMode: .alwaysTemplate)
    }
    
    func tapBackground(_ backgroundView: UIView, userdefultKey: String) {
        UserDefaults().setColor(selectedColor, forKey: userdefultKey)
        backgroundView.backgroundColor = selectedColor
    }
    
}
