//
//  CustomCalenderScrollView.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/24.
//

import UIKit

class CustomCalenderScrollView: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var scrollView:UIScrollView!
    
    @IBOutlet weak var thisWeek:CustomCalenderView!
    
    @IBOutlet weak var lastWeek:CustomCalenderView!
    
    @IBOutlet weak var twoWeekago:CustomCalenderView!
    
    @IBOutlet weak var threeWeekago:CustomCalenderView!
    
    var currentViewTag:Int = 3
    
    lazy var customCalenderViews:[CustomCalenderView] = [thisWeek, lastWeek, twoWeekago, threeWeekago]

    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }

    private func customInit(){
        loadNibContent()
        thisWeek.getSevenDays(targetDate: Date())
        
        if let date = Calendar.current.date(byAdding: .day, value: -7, to: Date()) {
            lastWeek.getSevenDays(targetDate: date)
        }
        
        if let date = Calendar.current.date(byAdding: .day, value: -14, to: Date()) {
            twoWeekago.getSevenDays(targetDate: date)
        }
        
        if let date = Calendar.current.date(byAdding: .day, value: -21, to: Date()) {
            threeWeekago.getSevenDays(targetDate: date)
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            scrollView.setContentOffset(CGPoint(x: thisWeek.frame.minX, y: 0), animated: false)
        }
        
        let toLeftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(toLeftSwipe(_:)))
        toLeftSwipe.direction = .left
        
        let toRightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(toRightSwipe(_:)))
        toRightSwipe.direction = .right
        
        self.addGestureRecognizer(toLeftSwipe)
        self.addGestureRecognizer(toRightSwipe)
        
        contentViewScrollViewAnimator()
        
    }
    
    private func contentViewScrollViewAnimator(){
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let targetView = customCalenderViews.filter({$0.tag == self.currentViewTag})[0]
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, animations: { 
                self.scrollView.contentOffset.x = targetView.frame.minX
            })
        }
    }
    
    @objc private func toLeftSwipe(_ swipe:UISwipeGestureRecognizer){
        currentViewTag = currentViewTag + 1
        if currentViewTag >= 3 {
            currentViewTag = 3
        }
        contentViewScrollViewAnimator()
            
    }
    
    @objc private func toRightSwipe(_ swipe:UISwipeGestureRecognizer){
        currentViewTag = currentViewTag - 1
        if currentViewTag <= 0 {
            currentViewTag = 0
        }
        contentViewScrollViewAnimator()
    }

}
