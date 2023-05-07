//
//  Extension.swift
//  futures
//
//  Created by Claud on 2022/12/15.
//

import Foundation
import UIKit

extension UITextField {
    
    func addBottomBorader(BoraderColor:UIColor){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: self.frame.height - 1, width: self.frame.width, height: 1.0)
        bottomLine.backgroundColor = BoraderColor.cgColor
        self.borderStyle = UITextField.BorderStyle.none
        self.layer.addSublayer(bottomLine)
    }
    
    func addLeftViewIcon(image:UIImage){
        let leftImageView = UIImageView()
        leftImageView.tintColor = .white
        leftImageView.image = image
        let leftView = UIView()
        leftView.addSubview(leftImageView)
        leftView.frame = CGRectMake(0, 0, 30, 25)
        leftImageView.frame = CGRectMake(0, 0, 25, 25)
        self.leftViewMode = .always
        self.leftView = leftView
    }
    
    func addRightViewIcon(image:UIImage){
        let rightViewImageView = UIImageView()
        rightViewImageView.tintColor = .white
        rightViewImageView.image = image
        let rightView = UIView()
        rightView.addSubview(rightViewImageView)
        rightView.frame = CGRectMake(0, 0, 30, 25)
        rightViewImageView.frame = CGRectMake(0, 0, 25, 25)
        self.rightViewMode = .always
        self.rightView = rightView
    }
    
    func addRightViewButton(btn:UIButton){
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        btn.frame = CGRect(x: CGFloat(self.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        self.rightView = btn
        self.rightViewMode = .always
    }
    
    func changePlaceholder(placeholder:String, color:UIColor) {
        self.attributedPlaceholder = NSAttributedString(string: placeholder,attributes: [NSAttributedString.Key.foregroundColor: color])
    }
    
}

extension Array {
    func toData()-> Data? {
        return try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: true)
    }
}

extension UIViewController {
    
    // With this extension you can access the MainViewController from the child view controllers.
    func revealViewController() -> CustomRootVC? {
        var viewController: UIViewController? = self
        
        if viewController != nil && viewController is CustomRootVC {
            return viewController! as? CustomRootVC
        }
        while (!(viewController is CustomRootVC) && viewController?.parent != nil) {
            viewController = viewController?.parent
        }
        if viewController is CustomRootVC {
            return viewController as? CustomRootVC
        }
        return nil
    }
    
}

extension Double {
    func formatNumber() -> String {
        let formater = NumberFormatter()
        formater.groupingSeparator = ","
        formater.numberStyle = .decimal
        return formater.string(from: NSNumber(value: self))!
    }
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0
            
            if scanner.scanHexInt64(&hexNumber) {
                r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                b = CGFloat(hexNumber & 0x0000ff) / 255
                a = 1
                
                self.init(red: r, green: g, blue: b, alpha: a)
                return
            }
        }
        return nil
    }
}

extension UIButton {
    
    func defaultImageToRight(){
        if #available(iOS 15, *){
            self.configuration?.imagePlacement = .trailing
            self.configuration?.imagePadding = 10
        }else{
            self.semanticContentAttribute = .forceRightToLeft
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        }
    }
    
}

extension UITableView {
    
    func setSeparatorLocation(){
        self.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
}

extension CaseIterable where Self: Equatable {
    
    func next() -> Self {
        let all = Self.allCases
        let idx = all.firstIndex(of: self)!
        let next = all.index(after: idx)
        return all[next == all.endIndex ? all.startIndex : next]
    }
    
}

extension Notification.Name {
    static let sideMenuAction = Notification.Name("sideMenuAction")
}

extension UIStackView {
    
    func removeFully(view: UIView) {
        removeArrangedSubview(view)
        view.removeFromSuperview()
    }
    
    func removeFullyAllArrangedSubviews() {
        arrangedSubviews.forEach { (view) in
            removeFully(view: view)
        }
    }
    
}

extension NSLayoutConstraint {
    
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem!, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
    
}

extension Encodable {
    
    var jsonString: String {
        guard let jsonData = try? JSONEncoder().encode(self),
              let jsonString = String(data: jsonData, encoding: .utf8)
        else {
            return ""
        }
        return jsonString
    }
    
}

extension String {

    static var uniqueString: String {
        UUID().uuidString.replacingOccurrences(of: "-", with: "")
    }
    
}

extension UIView {
    
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self.next
        while parentResponder != nil {
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
            parentResponder = parentResponder?.next
        }
        return nil
    }
    
}

extension NibOwnerLoadable {
    
    static var nib:UINib {
        UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
}

extension NibOwnerLoadable where Self:UIView {
    
    func loadNibContent() {
        guard let views = Self.nib.instantiate(withOwner: self, options: nil) as? [UIView],
        let contentView = views.first else {
            fatalError("Fail to load \(self) nib content")
        }
        self.addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
