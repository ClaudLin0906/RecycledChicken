//
//  CustomSegmentedControl.swift
//  AliShan
//
//  Created by 李東儒 on 2020/8/7.
//  Copyright © 2020 omniguider. All rights reserved.
//

import UIKit

protocol CustomSegmentedControlDelegate: class {
    func change(to index:Int)
}

class CustomSegmentedControl: UIView {

    enum CustomSegmentedControlType {
        case defaultType,singleType
    }
    
    private var buttonTitles: [String]!
    private var buttons: [UIButton]!
    private var bottomViews: [UIView]!
    private(set) var singleBottomView: UIView!
//    private(set) var bottomLineMinX: CGFloat = 0
    private(set) var bottomLineView: UIView!
    var type: CustomSegmentedControlType = .defaultType
    var selectorColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    var selectorBottomViewColor: UIColor = #colorLiteral(red: 0.6862745098, green: 0.5764705882, blue: 0.4431372549, alpha: 1)
    var defaultColor: UIColor = #colorLiteral(red: 0.6862745098, green: 0.5764705882, blue: 0.4431372549, alpha: 1)
    var defaultBottomViewColor: UIColor = #colorLiteral(red: 0.6862745098, green: 0.5764705882, blue: 0.4431372549, alpha: 1)
    var bottomLineColor:UIColor = #colorLiteral(red: 0.6862745098, green: 0.5764705882, blue: 0.4431372549, alpha: 1)
    
    weak var delegate:CustomSegmentedControlDelegate?
    
    var selectedIndex : Int = 0
    
    func setButtonTitles(_ titles:[String]) {
        if titles.count == 0 {return}
        buttonTitles = titles
        setupViews()
    }
    
    private func setupViews() {
        subviews.forEach({$0.removeFromSuperview()})
        createButtons()
        createStackView()
        (type == .defaultType) ? createBottomViews() : createSingleBottomView()
        createBottomLine()
    }
    
    private func createBottomLine() {
        bottomLineView = UIView()
        bottomLineView.backgroundColor = bottomLineColor
        addSubview(bottomLineView)
        bottomLineView.translatesAutoresizingMaskIntoConstraints = false
        bottomLineView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        bottomLineView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        bottomLineView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bottomLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    private func createButtons() {
        buttons = [UIButton]()
        buttons.removeAll()
        for buttonTitle in buttonTitles {
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
//            button.titleLabel?.font = .systemFont(ofSize: 16)
            button.titleLabel?.font = UIFont(name: "GenJyuuGothic-Normal", size: 15)
            button.addTarget(self, action:#selector(self.buttonAction(sender:)), for: .touchUpInside)
            button.setTitleColor(defaultColor, for: .normal)
            buttons.append(button)
        }
        buttons[selectedIndex].setTitleColor(selectorColor, for: .normal)
    }
    
    private func createBottomViews() {
        bottomViews = [UIView]()
        bottomViews.removeAll()
        for button in buttons {
            let view = UIView()
            view.backgroundColor = defaultBottomViewColor
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
            view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            view.widthAnchor.constraint(equalTo: button.widthAnchor, multiplier: 1).isActive = true
            view.heightAnchor.constraint(equalToConstant: 1).isActive = true
            bottomViews.append(view)
        }
        bottomViews[selectedIndex].backgroundColor = selectorBottomViewColor
    }
    
    private func createSingleBottomView() {
        singleBottomView = UIView()
        singleBottomView.backgroundColor = selectorBottomViewColor
        addSubview(singleBottomView)
        singleBottomView.translatesAutoresizingMaskIntoConstraints = false
        singleBottomView.centerXAnchor.constraint(equalTo: buttons[selectedIndex].centerXAnchor).isActive = true
        singleBottomView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        singleBottomView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        singleBottomView.heightAnchor.constraint(equalToConstant: 5).isActive = true
    }
    
    private func createStackView() {
        let stack = UIStackView(arrangedSubviews: buttons)
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stack.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        stack.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
    private func moveBottomView() {
//        bottomLineMinX = buttons[selectedIndex].frame.minX
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, animations: {
            self.singleBottomView.center.x = self.buttons[self.selectedIndex].center.x
        })
        
//        UIView.animate(withDuration: 0.3) {
//            self.singleBottomView.center.x = self.buttons[self.selectedIndex].center.x
//        }
    }
    
    func moveBottomViewNoAnimation(){
        self.singleBottomView.center.x = self.buttons[self.selectedIndex].center.x
    }
    
    @objc private func buttonAction(sender:UIButton) {
        for (buttonIndex, btn) in buttons.enumerated() {
            btn.setTitleColor(defaultColor, for: .normal)
            if btn == sender {
                selectedIndex = buttonIndex
                delegate?.change(to: selectedIndex)
                btn.setTitleColor(selectorColor, for: .normal)
                if type == .defaultType {
                    bottomViews.forEach({$0.backgroundColor = defaultBottomViewColor})
                    bottomViews[buttonIndex].backgroundColor = selectorBottomViewColor
                }else {
                    moveBottomView()
                }
            }
        }
    }
    
    func updateSelectedIndex(_ index: Int) {
        for (buttonIndex, btn) in buttons.enumerated() {
            btn.setTitleColor(defaultColor, for: .normal)
            if buttonIndex == index {
                selectedIndex = buttonIndex
                delegate?.change(to: selectedIndex)
                btn.setTitleColor(selectorColor, for: .normal)
                if type == .defaultType {
                    bottomViews.forEach({$0.backgroundColor = defaultBottomViewColor})
                    bottomViews[buttonIndex].backgroundColor = selectorBottomViewColor
                }else {
                    moveBottomView()
                }
            }
        }
    }
}
