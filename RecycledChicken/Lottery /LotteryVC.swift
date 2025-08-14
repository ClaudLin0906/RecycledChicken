//
//  LotteryVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/10.
//

import UIKit
import SkeletonView

class LotteryVC: CustomVC {
    
    @IBOutlet weak var lotteryTableView:UITableView!
    
    @IBOutlet weak var activityVoucherTableView:UITableView!
        
    @IBOutlet weak var partnerMerchantsTableView:UITableView!
    
    @IBOutlet weak var segmentedControl:CustomSegmentedControl!
    
    private var lotteryInfos:[LotteryInfo] = []
    
    private var activityVoucherInfos:[CommodityVoucherInfo] = []
    
    private var partnerMerchantsInfos:[CommodityVoucherInfo] = []
    
    private lazy var tableViews = [lotteryTableView, activityVoucherTableView, partnerMerchantsTableView]
    
    private var currentVisibleTableView: UITableView? {
        return [lotteryTableView, activityVoucherTableView, partnerMerchantsTableView].first { $0?.isHidden == false } ?? nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "activitiesLuckyDraws".localized
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit(){
        segmentedControl.type = .singleType
        segmentedControl.setButtonTitles(LotterySegmentedControlTitles)
        segmentedControl.delegate = self
        lotteryTableView.setSeparatorLocation()
        activityVoucherTableView.setSeparatorLocation()
        partnerMerchantsTableView.setSeparatorLocation()
        lotteryTableView.showAnimatedSkeleton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultNavigationBackBtn2()
        addNotificationKeyboard()
        getLotteryData()
        getEventCouponsData()
        getPartnerCouponsData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeNotificationKeyboard()
    }
    
    private func removeNotificationKeyboard(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func addNotificationKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardChange(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func getPartnerCouponsData() {
        NetworkManager.shared.getJSONBody(urlString: APIUrl.domainName + APIUrl.partnerCoupons, authorizationToken: CommonKey.shared.authToken) { [weak self] data, statusCode, errorMSG in
            guard let self = self, let data = data, statusCode == 200 else {
                showAlert(VC: self, title: "error".localized, message: errorMSG)
                return
            }
            partnerMerchantsInfos.removeAll()
            if let commodityVoucherInfos = try? JSONDecoder().decode([CommodityVoucherInfo].self, from: data) {
                commodityVoucherInfos.forEach { commodityVoucherInfo in
                    guard let category = commodityVoucherInfo.category else { return }
                    switch category {
                    case .partner:
                        self.partnerMerchantsInfos.append(commodityVoucherInfo)
                    default:
                        break
                    }
                }
                DispatchQueue.main.async {
                    self.partnerMerchantsTableView.reloadData()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        self.partnerMerchantsTableView.stopSkeletonAnimation()
                        self.view.hideSkeleton()
                    })
                }
            }
        }
    }
    
    private func getEventCouponsData() {
        NetworkManager.shared.getJSONBody(urlString: APIUrl.domainName + APIUrl.eventCoupons, authorizationToken: CommonKey.shared.authToken) { [weak self] data, statusCode, errorMSG in
            guard let self = self, let data = data, statusCode == 200 else {
                showAlert(VC: self, title: "error".localized, message: errorMSG)
                return
            }
            activityVoucherInfos.removeAll()
            if let commodityVoucherInfos = try? JSONDecoder().decode([CommodityVoucherInfo].self, from: data) {
                commodityVoucherInfos.forEach { commodityVoucherInfo in
                    guard let category = commodityVoucherInfo.category else { return }
                    switch category {
                    case .event:
                        self.activityVoucherInfos.append(commodityVoucherInfo)
                    default:
                        break
                    }
                }
                DispatchQueue.main.async {
                    self.activityVoucherTableView.reloadData()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        self.activityVoucherTableView.stopSkeletonAnimation()
                        self.view.hideSkeleton()
                    })
                }
            }
        }
    }
    //抽獎專區
    private func getLotteryData() {
        NetworkManager.shared.getJSONBody(urlString: APIUrl.domainName + APIUrl.checkLotteryItem, authorizationToken: CommonKey.shared.authToken) { data, statusCode, errorMSG in
            guard let data = data, statusCode == 200 else {
                showAlert(VC: self, title: "error".localized, message: errorMSG)
                return
            }
            if let lotteryInfos = try? JSONDecoder().decode([LotteryInfo].self, from: data) {
                self.lotteryInfos.removeAll()
                self.lotteryInfos.append(contentsOf: lotteryInfos)
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    lotteryTableView.reloadData()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        self.lotteryTableView.stopSkeletonAnimation()
                        self.view.hideSkeleton()
                    })
                }
            }
        }
    }
    
    private func getNumberOfRowsInSection(_ tableView:UITableView) -> Int {
        if tableView == lotteryTableView {
            return lotteryInfos.count
        }
        if tableView == activityVoucherTableView {
            return activityVoucherInfos.count
        }
        if tableView == partnerMerchantsTableView {
            return partnerMerchantsInfos.count
        }
        return 0
    }
    
    private func getCommodityVoucherInfo(_ tableView:UITableView, _ row:Int) -> CommodityVoucherInfo? {
        if tableView == activityVoucherTableView {
            return activityVoucherInfos[row]
        }
        if tableView == partnerMerchantsTableView {
            return partnerMerchantsInfos[row]
        }
        return nil
    }
}

extension LotteryVC {

    @objc func onKeyboardChange(_ note: Notification) {
        guard let tableView = currentVisibleTableView, let userInfo = note.userInfo, let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval, let curveRaw = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else { return }
        let kbFrameInView = view.convert(endFrame, from: nil)
        let overlap = max(0, view.bounds.maxY - kbFrameInView.origin.y)
        let insets = UIEdgeInsets(top: tableView.contentInset.top, left: 0, bottom: overlap, right: 0)
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: curveRaw << 16), animations: {
            tableView.contentInset = insets
            tableView.verticalScrollIndicatorInsets = insets
        })
    }

    @objc func onKeyboardHide(_ note: Notification) {
        guard let tableView = currentVisibleTableView, let duration = (note.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval), let curveRaw = (note.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt)else { return }
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: curveRaw << 16), animations: {
            tableView.contentInset.bottom = 0
            tableView.verticalScrollIndicatorInsets.bottom = 0
        })
    }
}

extension LotteryVC: SkeletonTableViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        LotteryTableViewCell.identifier
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        getNumberOfRowsInSection(skeletonView)
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, skeletonCellForRowAt indexPath: IndexPath) -> UITableViewCell? {
        nil
    }
    
}

extension LotteryVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard CurrentUserInfo.shared.isGuest == false else { return }
        let row = indexPath.row
        if tableView == lotteryTableView {
            if let navigationController = self.navigationController, let VC = UIStoryboard(name: "BuyLottery", bundle: Bundle.main).instantiateViewController(identifier: "BuyLottery") as? BuyLotteryVC {
                VC.lotteryInfo = lotteryInfos[indexPath.row]
                pushVC(targetVC: VC, navigation: navigationController)
            }
        }

        if tableView == activityVoucherTableView {
            let isUnlocked = activityVoucherInfos[row].isUnlocked ?? true
            if isUnlocked {
                if let navigationController = self.navigationController, let VC = UIStoryboard(name: "BuyCommodity", bundle: Bundle.main).instantiateViewController(identifier: "BuyCommodity") as? BuyCommodityVC {
                    VC.commodityVoucherInfo = activityVoucherInfos[row]
                    pushVC(targetVC: VC, navigation: navigationController)
                }
            }
        }
        
        if tableView == partnerMerchantsTableView  {
            let isUnlocked = partnerMerchantsInfos[row].isUnlocked ?? true
            if isUnlocked {
                if let navigationController = self.navigationController, let VC = UIStoryboard(name: "BuyCommodity", bundle: Bundle.main).instantiateViewController(identifier: "BuyCommodity") as? BuyCommodityVC {
                    VC.commodityVoucherInfo = partnerMerchantsInfos[row]
                    pushVC(targetVC: VC, navigation: navigationController)
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        getNumberOfRowsInSection(tableView)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == lotteryTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: LotteryTableViewCell.identifier, for: indexPath) as! LotteryTableViewCell
            let row = indexPath.row
            cell.setCell(lotteryInfos[row])
            return cell
        }
        
        if tableView == activityVoucherTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: ActivityVoucherTableViewCell.identifier, for: indexPath) as! ActivityVoucherTableViewCell
            cell.delegate = self
            let row = indexPath.row
            if let CommodityVoucherInfo = getCommodityVoucherInfo(tableView,row) {
                cell.setCell(CommodityVoucherInfo)
            }
            return cell
        }
        
        if tableView == partnerMerchantsTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: PartnerMerchantsTableViewTableViewCell.identifier, for: indexPath) as! PartnerMerchantsTableViewTableViewCell
            cell.delegate = self
            let row = indexPath.row
            if let CommodityVoucherInfo = getCommodityVoucherInfo(tableView,row) {
                cell.setCell(CommodityVoucherInfo)
            }
            return cell
        }
        
        return UITableViewCell()
    }

    private func openURL(_ link: String){
        guard let url = URL(string: link) else { return }
        UIApplication.shared.open(url)
    }
    
    private func checkVerify(_ name: String, _ category: String, _ veriftyCode: String, _ createTime: String, completion: @escaping (Bool) -> Void) {
        let checkVerifyCode = checkVerifyCode(name: name, createTime: createTime, category: category, unlockCode: veriftyCode)
        let checkVerifyCodeDic = try? checkVerifyCode.asDictionary()
        NetworkManager.shared.requestWithJSONBody(urlString: APIUrl.domainName + APIUrl.unlock,  parameters: checkVerifyCodeDic, authorizationToken: CommonKey.shared.authToken) { [weak self] data, statusCode, errorMSG in
            guard let data = data, statusCode == 200 else {
                showAlert(VC: self, title: "error".localized, message: errorMSG)
                return
            }
            let checkVerifyApiResult = try? JSONDecoder().decode(CheckVerifyApiResult.self, from: data)
            if let status = checkVerifyApiResult?.status, status == .success {
                completion(true)
            }else {
                completion(false)
            }
        }
    }
    
    private func checkHandle(_ isSuccess:Bool, _ category:CouponsCategory) {
        guard isSuccess else {
            showAlert(VC: self, title: "error".localized, message: "verifyCodeError".localized)
            return
        }
        switch category {
        case .ticket:
            break
        case .event:
            getEventCouponsData()
        case .partner:
            getPartnerCouponsData()
        }
    }
}

extension LotteryVC: CustomSegmentedControlDelegate {
    
    func change(to index: Int) {
        for tableView in tableViews {
            let tag = tableView?.tag
            if tag == index {
                tableView?.isHidden = false
            }
            if tag != index {
                tableView?.isHidden = true
            }
        }
    }
    
}

extension LotteryVC: ActivityVoucherTableViewCellDelegate {
    
    func activityVoucherButtonEvent(_ name: String, _ category: String, _ veriftyCode: String, _ createTime: String) {
        checkVerify(name, category, veriftyCode, createTime) { [weak self] isSuccess in
            guard let self = self else { return }
            checkHandle(isSuccess, .event)
        }
    }
    
    func activityVoucherHideImageEvent(_ link: String) {
        openURL(link)
    }
}

extension LotteryVC: PartnerMerchantsTableViewTableViewCellDelegate {
    
    func partnerMerchantsHideButtonEvent(_ name: String, _ category: String, _ veriftyCode: String, _ createTime: String) {
        checkVerify(name, category, veriftyCode, createTime) { [weak self] isSuccess in
            guard let self = self else { return }
            checkHandle(isSuccess, .partner)
        }
    }
    
    func partnerMerchantsHideImageEvent(_ link: String) {
        openURL(link)
    }
}
