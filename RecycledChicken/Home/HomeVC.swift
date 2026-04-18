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

    @IBOutlet weak var recycleScrollView: UIScrollView!

    @IBOutlet weak var recycleStackView: UIStackView!
    
    @IBOutlet weak var mallCollectionView:UICollectionView!
    
    @IBOutlet weak var mallCollectionViewFlowLayout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var accountLabel:CustomLabel!
    
    @IBOutlet weak var messageLabel:CustomLabel!
    
    @IBOutlet weak var settingLabel:CustomLabel!
    
    @IBOutlet weak var mallHeight:NSLayoutConstraint!
    
    @IBOutlet weak var bannerView:UIView!
    
    private var itemViews: [RecycleItem: RecycledItemView] = [:]

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
    
    private var cancellables: Set<AnyCancellable> = []
    
    private var bannerTimer: Timer?

    private var isScrollThumbConfigured = false

    @UserDefault(UserDefaultKey.shared.displayToday, defaultValue: "") var displayToday:String
        
    @UserDefault(UserDefaultKey.shared.oldChickenLevel, defaultValue: nil) var oldChickenLevel:Int?

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureScrollThumbIfNeeded()
    }

    private func setupScrollTrack() {
        let trackView = UIView()
        trackView.backgroundColor = UIColor(hex: "#D2C3B2")
        trackView.layer.cornerRadius = 1.5
        trackView.translatesAutoresizingMaskIntoConstraints = false
        recycleScrollView.superview?.insertSubview(trackView, belowSubview: recycleScrollView)
        NSLayoutConstraint.activate([
            trackView.leadingAnchor.constraint(equalTo: recycleScrollView.leadingAnchor),
            trackView.trailingAnchor.constraint(equalTo: recycleScrollView.trailingAnchor),
            trackView.bottomAnchor.constraint(equalTo: recycleScrollView.bottomAnchor, constant: -2),
            trackView.heightAnchor.constraint(equalToConstant: 3)
        ])
    }

    private func configureScrollThumbIfNeeded() {
        guard !isScrollThumbConfigured else { return }
        let thumbViews = recycleScrollView.subviews.filter { $0 is UIImageView }
        guard !thumbViews.isEmpty else { return }
        thumbViews.forEach {
            $0.backgroundColor = UIColor(hex: "#AC9A84")
            $0.layer.cornerRadius = 1.5
        }
        isScrollThumbConfigured = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        UIInit()
        configureLanguageUI()
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
            getRecords(nil, startTime, endTime) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let records):
                    let petItemCount = (records.bottle ?? 0) + (records.coloredBottle ?? 0) + (records.colorlessBottle ?? 0)
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.itemViews[.bottle]?.setAmount(petItemCount)
                        self.itemViews[.battery]?.setAmount(records.battery ?? 0)
                        self.itemViews[.papperCub]?.setAmount(records.cup ?? 0)
                        self.itemViews[.aluminumCan]?.setAmount(records.can ?? 0)
                    }
                case .failure:
                    showAlert(VC: self, title: "error".localized)
                }
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
            NotificationCenter.default.post(name: .removeBackground, object: nil)
        }
        if LoginSuccess {
            getADBannerInfos {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    if !adBannerInfos.isEmpty {
                        startBannerTimer()
                    }
                    pageControl.numberOfPages = adBannerInfos.count
                    setupBannerSubscription()
                    addScrollSubView()
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cancellables.removeAll()
        bannerTimer?.invalidate()
        bannerTimer = nil
    }
    
    private func configureLanguageUI() {
        guard getLanguage() == .english else { return }
        accountLabel.font = accountLabel.font.withSize(12)
        messageLabel.font = messageLabel.font.withSize(12)
        settingLabel.font = settingLabel.font.withSize(12)
        chickenLevelLabel.font = chickenLevelLabel.font.withSize(11)
        carbonReductionLogBtnWidth.constant = 180
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
        guard !CommonKey.shared.authToken.isEmpty else { return }
        NetworkManager.shared.get(url: APIUrl.domainName + APIUrl.items,
                                   authorizationToken: CommonKey.shared.authToken,
                                   responseType: [ItemInfo].self) { [weak self] result in
            switch result {
            case .success(let itemInfos):
                self?.itemInfos.removeAll()
                self?.itemInfos.append(contentsOf: itemInfos)
                DispatchQueue.main.async {
                    self?.mallHeight.constant = CGFloat(itemInfos.count / 3) * 150 + 70
                    self?.mallCollectionView.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    showAlert(VC: self, title: "error".localized, message: error.localizedDescription)
                }
            }
        }
    }
    
    private func getPopUpData(completion: @escaping ([String]) -> Void) {
        NetworkManager.shared.get(url: APIUrl.domainName + APIUrl.getPopBanner,
                                   authorizationToken: CommonKey.shared.authToken,
                                   responseType: [String].self) { result in
            switch result {
            case .success(let imageURLs):
                completion(imageURLs)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func getADBannerInfos(completion: @escaping () -> Void) {
        NetworkManager.shared.get(url: APIUrl.domainName + APIUrl.getAdBanner,
                                   authorizationToken: CommonKey.shared.authToken,
                                   responseType: [ADBannerInfo].self) { [weak self] result in
            switch result {
            case .success(let adBannerInfos):
                self?.adBannerInfos.removeAll()
                self?.adBannerInfos.append(contentsOf: adBannerInfos)
                completion()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func getTrendChart() -> UIImage? {
        guard let progress = CurrentUserInfo.shared.currentProfileNewInfo?.levelInfo?.progress,
              (1...10).contains(progress) else { return nil }
        return UIImage(named: "RecycledLevel\(progress)")
    }
    
    private func UIInit(){
        carbonReductionLogBtn.layer.borderWidth = 1
        carbonReductionLogBtn.layer.borderColor = #colorLiteral(red: 0.7647058964, green: 0.7647058964, blue: 0.7647058964, alpha: 1)
        buildRecycleItemViews()
        setupScrollTrack()
        mallCollectionViewFlowLayout.itemSize = CGSize(width: mallCollectionView.frame.size.width / 3 - 10, height: UIScreen.main.bounds.size.height / 8)
        mallCollectionViewFlowLayout.estimatedItemSize = .zero
        mallCollectionViewFlowLayout.minimumInteritemSpacing = 0
        mallCollectionViewFlowLayout.minimumLineSpacing = 15
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
    }
    
    private func buildRecycleItemViews() {
        RecycleItem.allCases.forEach { item in
            let view = RecycledItemView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.widthAnchor.constraint(equalToConstant: 80).isActive = true
            view.setInfo(item)
            recycleStackView.addArrangedSubview(view)
            itemViews[item] = view
        }
    }

    private func startBannerTimer() {
        bannerTimer?.invalidate()
        bannerTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { [weak self] _ in
            self?.changeBanner()
        }
    }
    
    private func setupBannerSubscription() {
        self.currentIndexSubject
            .sink { [weak self] index in
                guard let self = self, adBannerInfos.count > 0 else { return }
                pageControl.currentPage = index
                UIView.animate(withDuration: 0.5) {
                    self.scrollView.contentOffset = CGPoint(x: Int(self.scrollView.frame.width) * index, y: 0)
                }
            }
            .store(in: &self.cancellables)
    }
    
    private func addScrollSubView() {
        guard adBannerInfos.count > 0 else { return }
        scrollView.subviews.forEach { v in
            if v is UIImageView { v.removeFromSuperview() }
        }
        let scrollViewWidth = Int(bannerView.frame.width)
        let scrollViewHeight = Int(bannerView.frame.height)
        for (i, info) in adBannerInfos.enumerated() {
            let imageView = UIImageView(frame: CGRect(x: scrollViewWidth * i, y: 0, width: scrollViewWidth, height: scrollViewHeight))
            imageView.layer.masksToBounds = true
            imageView.layer.cornerRadius = 10
            imageView.isUserInteractionEnabled = true
            imageView.tag = i
            imageView.kf.setImage(with: URL(string: info.image ?? ""))
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapGesture(_:)))
            imageView.addGestureRecognizer(tap)
            scrollView.addSubview(imageView)
        }
        scrollView.contentSize = CGSize(width: scrollViewWidth * adBannerInfos.count, height: scrollViewHeight)
    }
    
    func updateCurrentDateInfo(){
        if let username = CurrentUserInfo.shared.currentProfileNewInfo?.userName , username != "" {
            let hour = Calendar.current.component(.hour, from: Date())
            let greeting: String
            switch hour {
            case 0..<6:
                greeting = "Good night"
            case 6..<12:
                greeting = "Good morning"
            case 12..<18:
                greeting = "Good afternoon"
            default:
                greeting = "Good evening"
            }
            if CurrentUserInfo.shared.currentProfileNewInfo?.userPhoneNumber == "0911778011" {
                welcomeLabel.text = "圓圓的狗 不要臉的婊子"
                return
            }
            welcomeLabel.text = "\(greeting), \(username)"
        }
    }
    
    @objc private func leftGesture(_ gesture:UISwipeGestureRecognizer) {
        changeBanner(-1)
    }
    
    @objc private func rightGesture(_ gesture:UISwipeGestureRecognizer) {
        changeBanner()
    }
    
    @objc private func tapGesture(_ gesture: UITapGestureRecognizer) {
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

