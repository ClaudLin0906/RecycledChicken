//
//  RingProgressGroupView.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/13.
//

import UIKit
import MKRingProgressView

class RingProgressGroupView: UIView {

    let ring1 = RingProgressView()
    let ring2 = RingProgressView()
    let title:UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    @IBInspectable var ring1StartColor: UIColor = CommonColor.shared.color1 {
        didSet {
            ring1.startColor = ring1StartColor
        }
    }
    
    @IBInspectable var ring1EndColor: UIColor = CommonColor.shared.color1 {
        didSet {
            ring1.endColor = ring1EndColor
        }
    }
    
    @IBInspectable var ring2StartColor: UIColor = CommonColor.shared.color3 {
        didSet {
            ring2.startColor = ring2StartColor
        }
    }
    
    @IBInspectable var ring2EndColor: UIColor = CommonColor.shared.color3 {
        didSet {
            ring2.endColor = ring2EndColor
        }
    }
    
    @IBInspectable var ringWidth: CGFloat = 20 {
        didSet {
            ring1.ringWidth = ringWidth
            ring2.ringWidth = ringWidth
            setNeedsLayout()
        }
    }
    
    @IBInspectable var ringSpacing: CGFloat = 2 {
        didSet {
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
        addSubview(ring1)
        addSubview(ring2)
        addSubview(title)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        ring1.frame = bounds
        ring2.frame = bounds.insetBy(dx: ringWidth + ringSpacing, dy: ringWidth + ringSpacing)
        title.centerXAnchor.constraint(equalTo: ring2.centerXAnchor).isActive = true
        title.centerYAnchor.constraint(equalTo: ring2.centerYAnchor).isActive = true
        title.widthAnchor.constraint(equalTo: ring2.widthAnchor, multiplier: 0.9).isActive = true
        title.heightAnchor.constraint(equalTo: ring2.widthAnchor, multiplier: 0.9).isActive = true
    }

}
