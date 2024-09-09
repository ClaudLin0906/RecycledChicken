//
//  HomeVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/6.
//

import UIKit
import Combine
class HomeVC: CustomRootVC {
    
    @IBOutlet weak var pageControl:UIPageControl!
        
    @IBOutlet weak var carbonReductionLogBtn:UIButton!
    
    @IBOutlet weak var carbonReductionLogBtnWidth:NSLayoutConstraint!
        
    @IBOutlet weak var welcomeLabel:UILabel!
    
    @IBOutlet weak var chickenLevelImageView:UIImageView!
    
    @IBOutlet weak var chickenLevelLabel:CustomLabel!
    
    @IBOutlet weak var trendChartImageView:UIImageView!
    
    @IBOutlet weak var petItemView:RecycledItemView!
        
    @IBOutlet weak var batteryItemView:RecycledItemView!
    
    @IBOutlet weak var papperCubItemView:RecycledItemView!
    
    @IBOutlet weak var aluminumCanItemView:RecycledItemView!
    
    @IBOutlet weak var mallCollectionView:UICollectionView!
    
    @IBOutlet weak var mallCollectionViewFlowLayout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var accountLabel:CustomLabel!
    
    @IBOutlet weak var messageLabel:CustomLabel!
    
    @IBOutlet weak var settingLabel:CustomLabel!
    
    @IBOutlet weak var mallHeight:NSLayoutConstraint!
    
    @IBOutlet weak var bannerView:UIView!
    
    private var scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = false
        return scrollView
    }()

    private var currentIndexSubject = PassthroughSubject<Int, Never>()
    
    private var currentIndex:Int = 0
        
    private var adBannerInfos:[ADBannerInfo] = []
    
    private var itemInfos:[ItemInfo] = []
//    
    private var cancellables: Set<AnyCancellable> = []

    @UserDefault(UserDefaultKey.shared.displayToday, defaultValue: "") var displayToday:String
        
    @UserDefault(UserDefaultKey.shared.oldChickenLevel, defaultValue: nil) var oldChickenLevel:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIInit()
        if getLanguage() == .english {
            accountLabel.font = accountLabel.font.withSize(12)
            messageLabel.font = messageLabel.font.withSize(12)
            settingLabel.font = settingLabel.font.withSize(12)
            chickenLevelLabel.font = chickenLevelLabel.font.withSize(11)
            carbonReductionLogBtnWidth.constant = 180
        }
//        NotificationCenter.default.addObserver(self, selector: #selector(receiveCalenderCell(_:)), name: .calenderCellOnCilck, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getUserNewInfo(VC: self) {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                let illustratedGuide = getIllustratedGuide(getChickenLevel())
                chickenLevelImageView.image = illustratedGuide.levelImage
                if let image = getTrendChart() {
                    trendChartImageView.image = image
                }
                self.chickenLevelLabel.text = "\("currentLevel".localized)：\(illustratedGuide.name.localized)"
                messagingSubscribe()
                self.updateCurrentDateInfo()
                self.checkChickenLevel()
            }
        }
        getItems()
        if let (startTime, endTime) = getStartAndEndDateOfMonth() {
            getRecords(nil, startTime, endTime) { [weak self] statusCode, errorMSG, useRecordInfos, battery, bottle, colorledBottle, colorlessBottle, can, cup in
                guard let self = self, let statusCode = statusCode, statusCode == 200 else {
                    showAlert(VC: self, title: "error".localized)
                    return
                }
                var petItemCount:Int = 0
                if let bottle = bottle {
                    petItemCount += bottle
                }
                if let colorledBottle = colorledBottle {
                    petItemCount += colorledBottle
                }
                if let colorlessBottle = colorlessBottle {
                    petItemCount += colorlessBottle
                }
                petItemView.setAmount(petItemCount)
                batteryItemView.setAmount(battery ?? 0)
                papperCubItemView.setAmount(cup ?? 0)
                aluminumCanItemView.setAmount(can ?? 0)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if FirstTime && LoginSuccess {
            FirstTime = false
            getPopUpData { imageURLs in
                DispatchQueue.main.async {
                    let adbannerView = ADBannerView(frame: UIScreen.main.bounds)
                    adbannerView.imageURLs.append(contentsOf: imageURLs)
                    Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
                        adbannerView.changeBanner()
                    }
                    keyWindow?.addSubview(adbannerView)
                }
            }
            getADBannerInfos {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    pageControl.numberOfPages = adBannerInfos.count
                    addScrollSubView()
                }
            }
            NotificationCenter.default.post(name: .removeBackground, object: nil)
        }
    }
    
    private func checkChickenLevel() {
        var showChicken = true
        guard let currentChickenLevel = CurrentUserInfo.shared.currentProfileNewInfo?.levelInfo?.chickenLevel?.rawValue else { return }
        
        if let oldChickenLevel = oldChickenLevel {
            if currentChickenLevel <= oldChickenLevel {
                showChicken = false
            }
        }
        oldChickenLevel = currentChickenLevel
        if showChicken {
            let chickeIntroduceView = ChickeIntroduceView(frame: UIScreen.main.bounds)
            fadeInOutAni(showView: chickeIntroduceView, finishAction: nil)
        }
    }
    
    private func getItems() {
        NetworkManager.shared.getJSONBody(urlString: APIUrl.domainName + APIUrl.items, authorizationToken: CommonKey.shared.authToken) { data, statusCode, errorMSG in
            guard let data = data, statusCode == 200 else {
                showAlert(VC: self, title: "error".localized, message: errorMSG)
                return
            }
            if let itemInfos = try? JSONDecoder().decode([ItemInfo].self, from: data) {
                self.itemInfos.removeAll()
                self.itemInfos.append(contentsOf: itemInfos)
                DispatchQueue.main.async {
                    self.mallHeight.constant = CGFloat(itemInfos.count / 3 * 150) + 70
                    self.mallCollectionView.reloadData()
                }
            }
        }
    }
    
    private func getPopUpData(completion: @escaping ([String]) -> Void) {
        NetworkManager.shared.getJSONBody(urlString: APIUrl.domainName + APIUrl.getPopBanner, authorizationToken: CommonKey.shared.authToken) { data, statusCode, errorMSG in
            guard let data = data, statusCode == 200 else {
                print(errorMSG?.localized ?? "something error")
                return
            }
            if let imageURLs = try? JSONDecoder().decode([String].self, from: data) {
                completion(imageURLs)
            }
        }
    }
    
    private func getADBannerInfos(completion: @escaping () -> Void) {
        NetworkManager.shared.getJSONBody(urlString: APIUrl.domainName + APIUrl.getAdBanner, authorizationToken: CommonKey.shared.authToken) { data, statusCode, errorMSG in
            guard let data = data, statusCode == 200 else {
                print(errorMSG?.localized ?? "something error")
                return
            }
            if let adBannerInfos = try? JSONDecoder().decode([ADBannerInfo].self, from: data) {
                self.adBannerInfos.removeAll()
                self.adBannerInfos.append(contentsOf: adBannerInfos)
                completion()
            }
        }
    }
    
    private func getTrendChart() -> UIImage?{
        if let levelInfo = CurrentUserInfo.shared.currentProfileNewInfo?.levelInfo {
            var image:UIImage?
            switch levelInfo.progress {
            case 1:
                image = UIImage(named: "RecycledLevel1")
            case 2:
                image = UIImage(named: "RecycledLevel2")
            case 3:
                image = UIImage(named: "RecycledLevel3")
            case 4:
                image = UIImage(named: "RecycledLevel4")
            case 5:
                image = UIImage(named: "RecycledLevel5")
            case 6:
                image = UIImage(named: "RecycledLevel6")
            case 7:
                image = UIImage(named: "RecycledLevel7")
            case 8:
                image = UIImage(named: "RecycledLevel8")
            case 9:
                image = UIImage(named: "RecycledLevel9")
            case 10:
                image = UIImage(named: "RecycledLevel10")
            default:
                image = nil
            }
            return image
        }
        return nil
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        if FirstTime && LoginSuccess {
//            if displayToday != getDates(i: 0, currentDate: Date()).0 {
//                FirstTime = false
//                let  adbannerView = ADBannerView(frame: UIScreen.main.bounds)
//                Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
//                    adbannerView.changeBanner()
//                }
//                keyWindow?.addSubview(adbannerView)
//            }
//            NotificationCenter.default.post(name: .removeBackground, object: nil)
//        }
//        updateCurrentDateInfo()
//    }
    
    private func UIInit(){
        carbonReductionLogBtn.layer.borderWidth = 1
        carbonReductionLogBtn.layer.borderColor = #colorLiteral(red: 0.7647058964, green: 0.7647058964, blue: 0.7647058964, alpha: 1)
        petItemView.setInfo(.bottle)
        batteryItemView.setInfo(.battery)
        papperCubItemView.setInfo(.papperCub)
        aluminumCanItemView.setInfo(.aluminumCan)
        mallCollectionViewFlowLayout.itemSize = CGSize(width: mallCollectionView.frame.size.width / 3 - 5, height: 100)
        mallCollectionViewFlowLayout.estimatedItemSize = .zero
        mallCollectionViewFlowLayout.minimumInteritemSpacing = 0
        mallCollectionViewFlowLayout.minimumLineSpacing = 0
        mallCollectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        bannerView.addSubview(scrollView)
        scrollView.centerXAnchor.constraint(equalTo: bannerView.centerXAnchor).isActive = true
        scrollView.centerYAnchor.constraint(equalTo: bannerView.centerYAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: bannerView.widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: bannerView.heightAnchor).isActive = true
        let leftGesture = UISwipeGestureRecognizer(target: self, action: #selector(leftGesture(_:)))
        let rightGesture = UISwipeGestureRecognizer(target: self, action: #selector(rightGesture(_:)))
        rightGesture.direction = .left
        leftGesture.direction = .right
        scrollView.addGestureRecognizer(leftGesture)
        scrollView.addGestureRecognizer(rightGesture)
        self.currentIndexSubject
            .sink { [weak self] index in
                guard let self = self, adBannerInfos.count > 0 else { return }
                pageControl.currentPage = index
                UIView.animate(withDuration: 0.5) {
                    self.scrollView.contentOffset = CGPoint(x: Int(self.scrollView.frame.width) * index, y: 0)
                }
            }
            .store(in: &self.cancellables)
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true){ _ in
            self.changeBanner()
        }
    }
    
    private func addScrollSubView() {
        guard adBannerInfos.count > 0 else { return }
        scrollView.subviews.forEach { v in
            if v is UIImageView {
                v.removeFromSuperview()
            }
        }
        var currentX = 0
        let scrollViewWidth:Int = Int(bannerView.frame.width)
        let scrollViewHeight:Int = Int(bannerView.frame.height)
        for i in 0...adBannerInfos.count - 1 {
            let imageView = UIImageView(frame: CGRect(x: currentX, y: 0, width: scrollViewWidth, height: scrollViewHeight))
            imageView.layer.masksToBounds = true
            imageView.layer.cornerRadius = 10
            imageView.isUserInteractionEnabled = true
            imageView.tag = i
            imageView.kf.setImage(with: URL(string: adBannerInfos[i].image ?? ""))
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapGesture(_:)))
            imageView.addGestureRecognizer(tap)
            scrollView.addSubview(imageView)
            currentX += scrollViewWidth
        }
        scrollView.contentSize = CGSize(width: currentX, height: scrollViewHeight)
    }
    
    func updateCurrentDateInfo(){
        if let username = CurrentUserInfo.shared.currentProfileNewInfo?.userName , username != "" {
            welcomeLabel.text = "Good morning, \(username)"
        }
//        getChoseDateRecycleAmount()
    }
    
    @objc private func leftGesture(_ gesture:UISwipeGestureRecognizer) {
        changeBanner(-1)
    }
    
    @objc private func rightGesture(_ gesture:UISwipeGestureRecognizer) {
        changeBanner()
    }
    
    @objc private func tapGesture(_ gesture:UISwipeGestureRecognizer) {
        if let v = gesture.view, let imageView = v as? UIImageView {
            let index = imageView.tag
            if let urlStr = adBannerInfos[index].URL, let url = URL(string: urlStr), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    }
    
    private func changeBanner(_ changeIndex:Int = 1) {
        guard adBannerInfos.count > 0 else { return }
        currentIndex += changeIndex
        if currentIndex > (adBannerInfos.count - 1) {
            currentIndex = 0
        }
        if currentIndex < 0 {
            currentIndex = adBannerInfos.count - 1
        }
        currentIndexSubject.send(currentIndex)
    }
    
    private func signAlert(_ title:String){
        let alertAction = UIAlertAction(title: "註冊", style: .default) { _ in
            loginOutRemoveObject()
            goToSignVC()
        }
        let cancelAction = UIAlertAction(title: "cancel".localized, style: .cancel)
        showAlert(VC: self, title: title, message: nil, alertAction: alertAction, cancelAction: cancelAction)
    }
    
    @IBAction func goToCarbonReductionLog(_ sender:UIButton) {
        guard CurrentUserInfo.shared.isGuest == false else {
            signAlert("加入修復計畫，解鎖更多碳竹雞角色！")
            return
        }
        
        if let navigationController = self.navigationController, let VC = UIStoryboard(name: "CarbonReductionLog", bundle: Bundle.main).instantiateViewController(identifier: "CarbonReductionLog") as? CarbonReductionLogVC {
            pushVC(targetVC: VC, navigation: navigationController)
        }
        
    }
    
    @IBAction func goToProfile(_ sender:UIButton) {
        if let navigationController = self.navigationController, let VC = UIStoryboard(name: "Profile", bundle: Bundle.main).instantiateViewController(identifier: "Profile") as? ProfileVC {
            pushVC(targetVC: VC, navigation: navigationController)
        }
    }
    
    @IBAction func goToPersonMessage(_ sender:UIButton) {
        guard CurrentUserInfo.shared.isGuest == false else {
            signAlert("請先註冊為會員，加入泥滑島修復計畫！")
            return
        }
        
        if let navigationController = self.navigationController, let VC = UIStoryboard(name: "PersonMessage", bundle: Bundle.main).instantiateViewController(identifier: "PersonMessage") as? PersonMessageVC {
            pushVC(targetVC: VC, navigation: navigationController)
        }
        
    }
    
    @IBAction func goToSettingMenu(_ sender:UIButton) {
        if let navigationController = self.navigationController, let VC = UIStoryboard(name: "SettingMenu", bundle: Bundle.main).instantiateViewController(identifier: "SettingMenu") as? SettingMenuVC {
            pushVC(targetVC: VC, navigation: navigationController)
        }
    }
    
    @IBAction func openURLForMall(_ sender:UIButton) {
        guard let url = URL(string: APIUrl.mall) else { return }
        UIApplication.shared.open(url)
    }
}


extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = indexPath.row
        let itemInfo = itemInfos[row]
        if let productLink = itemInfo.productLink, let productUrl = URL(string: productLink) {
            if let navigationController = self.navigationController, let VC = UIStoryboard(name: "MallProduct", bundle: Bundle.main).instantiateViewController(identifier: "MallProduct") as? MallProductVC {
                VC.setProductURL(productUrl)
                pushVC(targetVC: VC, navigation: navigationController)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemInfos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MallCollectionViewCell", for: indexPath) as! MallCollectionViewCell
        cell.setCell(itemInfos[indexPath.row])
        return cell
    }
    
}
