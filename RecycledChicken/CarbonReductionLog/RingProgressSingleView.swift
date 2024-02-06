//
//  RingProgressSingleView.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2024/2/6.
//

import UIKit
import MKRingProgressView

class RingProgressSingleView: UIView {

    let ring = RingProgressView()
    
    let congratulationsTitle:UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let congratulationsContent:UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    @IBInspectable var ringStartColor: UIColor = CommonColor.shared.color1 {
        didSet {
            ring.startColor = ringStartColor
        }
    }
    
    @IBInspectable var ringEndColor: UIColor = CommonColor.shared.color1 {
        didSet {
            ring.endColor = ringEndColor
        }
    }
    
    @IBInspectable var ringWidth: CGFloat = 20 {
        didSet {
            ring.ringWidth = ringWidth
            setNeedsLayout()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        addSubview(ring)
        addSubview(congratulationsTitle)
        addSubview(congratulationsContent)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        ring.frame = bounds
        
        congratulationsTitle.centerXAnchor.constraint(equalTo: ring.centerXAnchor).isActive = true
        congratulationsTitle.centerYAnchor.constraint(equalTo: ring.centerYAnchor,constant: -30).isActive = true
        congratulationsTitle.widthAnchor.constraint(equalTo: ring.widthAnchor, multiplier: 0.7).isActive = true
        congratulationsTitle.heightAnchor.constraint(equalToConstant: 20).isActive = true
        congratulationsTitle.font = UIFont(name: "jf-openhuninn-2.0", size: 10)
        
        congratulationsContent.centerXAnchor.constraint(equalTo: congratulationsTitle.centerXAnchor).isActive = true
        congratulationsContent.topAnchor.constraint(equalTo: congratulationsTitle.bottomAnchor, constant: 10).isActive = true
        congratulationsContent.widthAnchor.constraint(equalTo: congratulationsTitle.widthAnchor).isActive = true
        congratulationsContent.heightAnchor.constraint(equalToConstant: 40).isActive = true
        let attrString = NSMutableAttributedString(attributedString: congratulationsContent.attributedText!)
        attrString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "GenJyuuGothic-Normal", size: 10)!, range: NSMakeRange(0, attrString.length))
        attrString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(3.0), range: NSRange(location: 0, length: attrString.length))
        congratulationsContent.attributedText = attrString
    }

}
