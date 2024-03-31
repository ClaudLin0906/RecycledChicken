//
//  RingProgressSingleView.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2024/2/6.
//

import UIKit
import MKRingProgressView

class RingProgressSingleView: UIView {

    private let ring = RingProgressView()
    
    private lazy var targetLabel = labelInit()
    
    private lazy var countLabel = labelInit()
    
    private lazy var slashLabel = labelInit()
    
    private lazy var totalLabel = labelInit()
    
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
    
    @IBInspectable var ringWidth: CGFloat = 10 {
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
//        addSubview(targetLabel)
//        addSubview(slashLabel)
//        addSubview(totalLabel)
//        addSubview(countLabel)
    }
    
    private func labelInit() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        ring.translatesAutoresizingMaskIntoConstraints = false
        
        ring.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        ring.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        ring.widthAnchor.constraint(equalTo: widthAnchor, constant: 0).isActive = true
        ring.heightAnchor.constraint(equalTo: heightAnchor, constant: 0).isActive = true
//        targetLabel.text = "TARGET"
//        targetLabel.centerXAnchor.constraint(equalTo: ring.centerXAnchor).isActive = true
//        targetLabel.centerYAnchor.constraint(equalTo: ring.centerYAnchor,constant: -20).isActive = true
//        targetLabel.widthAnchor.constraint(equalTo: ring.widthAnchor, multiplier: 0.7).isActive = true
//        targetLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        targetLabel.font = UIFont(name: "GenJyuuGothic-Heavy", size: 15)
//        
//        let totalColor = #colorLiteral(red: 0.6571641564, green: 0.6571640372, blue: 0.6571640372, alpha: 1)
//        
//        slashLabel.text = "/"
//        slashLabel.textColor = totalColor
//        slashLabel.font = UIFont(name: "GenJyuuGothic-Medium", size: 10)
//        slashLabel.centerXAnchor.constraint(equalTo: targetLabel.centerXAnchor).isActive = true
//        slashLabel.centerYAnchor.constraint(equalTo: ring.centerYAnchor,constant: 20).isActive = true
//        
//        totalLabel.textColor = totalColor
//        totalLabel.font = UIFont(name: "GenJyuuGothic-Medium", size: 10)
//        totalLabel.centerYAnchor.constraint(equalTo: slashLabel.centerYAnchor).isActive = true
//        totalLabel.leadingAnchor.constraint(equalTo: slashLabel.trailingAnchor, constant: 5).isActive = true
//        
//        countLabel.font = UIFont(name: "jf-openhuninn-2.0", size: 25)
//        countLabel.bottomAnchor.constraint(equalTo: slashLabel.bottomAnchor).isActive = true
//        countLabel.trailingAnchor.constraint(equalTo: slashLabel.leadingAnchor, constant: -5).isActive = true
        
//        ring.layer.shadowOffset = CGSize(width: 1, height: 1)
//        ring.layer.shadowOpacity = 0.2
    }
    
    func setCount(_ count:Double, _ total:Double, _ startColor:UIColor, _ endColor:UIColor) {
        countLabel.text = String(Int(count))
        totalLabel.text = String(Int(total))
        ring.progress = count / total
        ringStartColor = startColor
        ringEndColor = endColor
    }

}
