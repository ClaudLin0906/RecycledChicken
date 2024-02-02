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
    
    @IBOutlet weak var collectionView:UICollectionView!
    
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var pageControl:UIPageControl!
    
    @IBOutlet weak var checkBox:M13Checkbox!
    
    private var currentIndexSubject = PassthroughSubject<Int, Never>()

    private var currentIndex:Int = 0
    
    private var bannerCount:Int = 4
    
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
    
    @IBAction func btnHandle(_ sender:UIButton) {
        if checkBox.checkState == .checked {
            displayToday = getDates(i: 0, currentDate: Date()).0
        }
        removeFromSuperview()
    }
    
    private func customInit(){
        loadNibContent()
        checkBox.boxType = .square
        checkBox.stateChangeAnimation = .fill
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "ADBannerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ADBannerCollectionViewCell")
        collectionViewFlowLayout.itemSize = collectionView.frame.size
        collectionViewFlowLayout.estimatedItemSize = .zero
        collectionViewFlowLayout.minimumInteritemSpacing = 0
        collectionViewFlowLayout.minimumLineSpacing = 0
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        pageControl.currentPage = currentIndex
        pageControl.numberOfPages = bannerCount
        currentIndexSubject
            .sink { [weak self] index in
                self?.pageControl.currentPage = index
                self?.collectionView.selectItem(at: IndexPath(item: index, section: 0), animated: true, scrollPosition: .centeredHorizontally)
            }
            .store(in: &cancellables)
    }
    
    func changeBanner() {
        currentIndex += 1
        if currentIndex > (bannerCount - 1) {
            currentIndex = 0
        }
        currentIndexSubject.send(currentIndex)
    }

}

extension ADBannerView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        bannerCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ADBannerCollectionViewCell", for: indexPath) as! ADBannerCollectionViewCell
        return cell

    }
    
}

