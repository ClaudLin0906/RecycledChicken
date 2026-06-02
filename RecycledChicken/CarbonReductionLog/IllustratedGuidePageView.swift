//
//  IllustratedGuidePageView.swift
//  RecycledChicken
//

import UIKit
import Combine

class IllustratedGuidePageView: UIView, NibOwnerLoadable {

    // MARK: - ScrollView（程式碼建立，同 ADBannerView 寫法）

    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = false
        return scrollView
    }()

    // MARK: - IBOutlets（XIB 定義）

    @IBOutlet weak var pageContainerView: UIView!
    
    @IBOutlet weak var pageControl: UIPageControl!

    // MARK: - Private

    private var currentIndexSubject = PassthroughSubject<Int, Never>()
    private var currentIndex: Int = 0
    private var pageDatas: [IllustratedGuideTableData] = []
    private var cancellables: Set<AnyCancellable> = []
    private var isPagesBuilt = false

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        addPageSubViews()
    }

    // MARK: - Setup（同 ADBannerView customInit 結構）

    private func customInit() {
        loadNibContent()
        self.backgroundColor = .clear

        // scrollView 加進 pageContainerView（同 ADBannerView: bannnerView.addSubview(scrollView)）
        pageContainerView.addSubview(scrollView)
        scrollView.centerXAnchor.constraint(equalTo: pageContainerView.centerXAnchor).isActive = true
        scrollView.centerYAnchor.constraint(equalTo: pageContainerView.centerYAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: pageContainerView.widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: pageContainerView.heightAnchor).isActive = true

        pageControl.currentPage = currentIndex

        // Combine 驅動頁面動畫（同 ADBannerView currentIndexSubject）
        currentIndexSubject
            .sink { [weak self] index in
                guard let self = self else { return }
                // 10 頁 → 4 個點的比例映射
                let maxDot = self.pageControl.numberOfPages - 1
                let maxPage = max(self.pageDatas.count - 1, 1)
                self.pageControl.currentPage = index * maxDot / maxPage
                UIView.animate(withDuration: 0.3) {
                    self.scrollView.contentOffset = CGPoint(
                        x: CGFloat(index) * self.scrollView.frame.width,
                        y: 0
                    )
                }
            }
            .store(in: &cancellables)

        // 手勢加在 scrollView 上（同 ADBannerView）
        let leftGesture = UISwipeGestureRecognizer(target: self, action: #selector(leftGesture(_:)))
        leftGesture.direction = .left
        scrollView.addGestureRecognizer(leftGesture)

        let rightGesture = UISwipeGestureRecognizer(target: self, action: #selector(rightGesture(_:)))
        rightGesture.direction = .right
        scrollView.addGestureRecognizer(rightGesture)

        loadAllLevelData()
    }

    // MARK: - 資料載入（參考 IllustratedGuideVC 邏輯）

    private func loadAllLevelData() {
        let userLevel = CurrentUserInfo.shared.currentProfileNewInfo?.levelInfo?.chickenLevel
        pageDatas = IllustratedGuideModelLevel.allCases.map { level in
            let isRead = (userLevel?.rawValue ?? 0) >= level.rawValue
            return IllustratedGuideTableData(illustratedGuideModelLevel: level, isRead: isRead)
        }
        pageControl.numberOfPages = 4
    }

    // MARK: - 頁面內容建立（同 ADBannerView addScrollSubView）

    private func addPageSubViews() {
        guard !pageDatas.isEmpty, !isPagesBuilt else { return }
        isPagesBuilt = true
        
        scrollView.subviews.forEach { $0.removeFromSuperview() }
        
        var previousPage: UIView? = nil
        for data in pageDatas {
            previousPage = createPageView(for: data, previousPage: previousPage)
        }
        
        if let last = previousPage {
            last.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        }
    }
    
    private func createPageView(for data: IllustratedGuideTableData, previousPage: UIView?) -> UIView {
        let pageView = UIView()
        pageView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(pageView)
        
        NSLayoutConstraint.activate([
            pageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            pageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            pageView.widthAnchor.constraint(equalTo: pageContainerView.widthAnchor),
            pageView.heightAnchor.constraint(equalTo: pageContainerView.heightAnchor, constant: -40)
        ])
        
        if let prev = previousPage {
            pageView.leadingAnchor.constraint(equalTo: prev.trailingAnchor).isActive = true
        } else {
            pageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        }
        
        let guide = getIllustratedGuide(data.illustratedGuideModelLevel)
        
        // 背景圖
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.image = guide.guideBackgroundImage
        pageView.addSubview(imageView)
        imageView.pinToEdges(of: pageView)
        
        // 下方資訊卡
        let infoCard: UIView
        if data.isRead {
            let unlockedView = IllustratedGuideFirstInfoView()
            let guideText = guide.discover.isEmpty ? guide.guide : guide.discover
            unlockedView.setInfo(guide.iconImage, name: guide.name, type: guide.title, guide: guideText)
            unlockedView.backgroundColor = .white
            infoCard = unlockedView
        } else {
            let lockedView = IllustratedGuideLockedInfoView()
            lockedView.setExperienceText(guide.experience)
            infoCard = lockedView
        }
        
        infoCard.layer.cornerRadius = 20
        infoCard.clipsToBounds = true
        pageView.addSubview(infoCard)
        infoCard.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            infoCard.leadingAnchor.constraint(equalTo: pageView.leadingAnchor),
            infoCard.trailingAnchor.constraint(equalTo: pageView.trailingAnchor),
            infoCard.bottomAnchor.constraint(equalTo: pageView.bottomAnchor),
            infoCard.heightAnchor.constraint(equalToConstant: 130)
        ])
        
        return pageView
    }

    // MARK: - 手勢（同 ADBannerView leftGesture / rightGesture）

    @objc private func leftGesture(_ gesture: UISwipeGestureRecognizer) {
        changePage()
    }

    @objc private func rightGesture(_ gesture: UISwipeGestureRecognizer) {
        changePage(-1)
    }

    // MARK: - Public

    /// 切換頁面，changeIndex: 1 = 下一頁，-1 = 上一頁（同 ADBannerView changeBanner）
    func changePage(_ changeIndex: Int = 1) {
        guard pageDatas.count > 0 else { return }
        let newIndex = currentIndex + changeIndex
        guard newIndex >= 0, newIndex < pageDatas.count else { return }
        currentIndex = newIndex
        currentIndexSubject.send(currentIndex)
    }

    /// 重新載入最新等級資料，可在 viewWillAppear 呼叫
    func reload() {
        loadAllLevelData()
        scrollView.subviews.forEach { $0.removeFromSuperview() }
        isPagesBuilt = false
        currentIndex = 0
        currentIndexSubject.send(currentIndex)
        setNeedsLayout()
    }
}

// MARK: - Layout Helper

private extension UIView {
    func pinToEdges(of container: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: container.topAnchor),
            self.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            self.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: container.trailingAnchor)
        ])
    }
}

