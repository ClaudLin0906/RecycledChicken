//
//  ADBannerView.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2024/1/31.
//

import UIKit
import Combine
import M13Checkbox
class ADBannerView: UIView, NibOwnerLoadable {
    
    private var scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = false
        return scrollView
    }()
    
    @IBOutlet weak var bannnerView:UIView!
        
    @IBOutlet weak var pageControl:UIPageControl!
    
    @IBOutlet weak var checkBox:M13Checkbox!
    
    private var currentIndexSubject = PassthroughSubject<Int, Never>()

    private var currentIndex:Int = 0
    
//    private var bannerCount:Int = 4
    
//    var adBannerInfos:[ADBannerInfo] = []
    
    var imageURLs:[String] = []
    {
        willSet {
            pageControl.numberOfPages = newValue.count
        }
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    @UserDefault(UserDefaultKey.shared.displayToday, defaultValue: nil) var displayToday:String?
    
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
        addScrollSubView()
    }
    
    @IBAction func btnHandle(_ sender:UIButton) {
        if checkBox.checkState == .checked {
            displayToday = getDates(i: 0, currentDate: Date()).0
        }
        removeFromSuperview()
    }
    
    override func willRemoveSubview(_ subview: UIView) {
        super.willRemoveSubview(subview)
        cancellables.removeAll()
    }
    
    private func addScrollSubView() {
        guard imageURLs.count > 0 else { return }
        var currentX = 0
        let scrollViewWidth:Int = Int(self.frame.width * 0.8)
        let scrollViewHeight:Int = Int(self.frame.height * 0.5)
        imageURLs.forEach { url in
            let imageView = UIImageView(frame: CGRect(x: currentX, y: 0, width: scrollViewWidth, height: scrollViewHeight))
            imageView.layer.masksToBounds = true
            imageView.layer.cornerRadius = 10
            imageView.kf.setImage(with: URL(string: url))
            scrollView.addSubview(imageView)
            currentX += scrollViewWidth
        }
        scrollView.contentSize = CGSize(width: currentX, height: scrollViewHeight)
    }
    
    private func customInit(){
        loadNibContent()
        bannnerView.addSubview(scrollView)
        scrollView.centerXAnchor.constraint(equalTo: bannnerView.centerXAnchor).isActive = true
        scrollView.centerYAnchor.constraint(equalTo: bannnerView.centerYAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: bannnerView.widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: bannnerView.heightAnchor).isActive = true
        checkBox.boxType = .square
        checkBox.stateChangeAnimation = .fill
        pageControl.currentPage = currentIndex
        currentIndexSubject
            .sink { [weak self] index in
                self?.pageControl.currentPage = index
                UIView.animate(withDuration: 0.5) {
                    self?.scrollView.contentOffset = CGPoint(x: Int(self?.scrollView.frame.width ?? 0) * index, y: 0)
                }
            }
            .store(in: &cancellables)
        let leftGesture = UISwipeGestureRecognizer(target: self, action: #selector(leftGesture(_:)))
        let rightGesture = UISwipeGestureRecognizer(target: self, action: #selector(rightGesture(_:)))
        rightGesture.direction = .right
        leftGesture.direction = .left
        scrollView.addGestureRecognizer(leftGesture)
        scrollView.addGestureRecognizer(rightGesture)
    }
    
    @objc private func leftGesture(_ gesture:UISwipeGestureRecognizer) {
        changeBanner()
    }
    
    @objc private func rightGesture(_ gesture:UISwipeGestureRecognizer) {
        changeBanner(-1)
    }
    
    func changeBanner(_ changeIndex:Int = 1) {
        guard imageURLs.count > 0 else { return }
        currentIndex += changeIndex
        if currentIndex > (imageURLs.count - 1) {
            currentIndex = 0
        }
        if currentIndex < 0 {
            currentIndex = imageURLs.count - 1
        }
        currentIndexSubject.send(currentIndex)
    }
}

