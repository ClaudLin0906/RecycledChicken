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
    
    @IBInspectable var ring1StartColor: UIColor = .red {
        didSet {
            ring1.startColor = ring1StartColor
        }
    }
    
    @IBInspectable var ring1EndColor: UIColor = .blue {
        didSet {
            ring1.endColor = ring1EndColor
        }
    }
    
    @IBInspectable var ring2StartColor: UIColor = .red {
        didSet {
            ring2.startColor = ring2StartColor
        }
    }
    
    @IBInspectable var ring2EndColor: UIColor = .blue {
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
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        ring1.frame = bounds
        ring2.frame = bounds.insetBy(dx: ringWidth + ringSpacing, dy: ringWidth + ringSpacing)
    }

}