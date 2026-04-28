//
//  AmountView.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/16.
//

import UIKit

class AmountView: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var storeName:UILabel!
    
    @IBOutlet weak var stackView:UIStackView!
    
    var mapInfo:MapInfo?

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
    }
    
    @IBAction func closeAction(_ sender:UIButton) {
        self.isHidden = true
    }
    
    func setAmount(_ info:MapInfo) {
        stackView.removeFullyAllArrangedSubviews()
        self.isHidden = false
        storeName.text = info.name
        if let status = info.machineStatus, status != .submit {
            stackView.addArrangedSubview(statusRowView())
            return
        }
        if let machineRemaining = info.machineRemaining {
            
            if let battery = machineRemaining.battery {
                let label = labelInit("電池還可投入：\(battery)")
                stackView.addArrangedSubview(label)
            }
            
            if let bottle = machineRemaining.bottle {
                let label = labelInit("寶特瓶還可投入：\(bottle)")
                stackView.addArrangedSubview(label)
            }
            
            if let coloredBottle = machineRemaining.coloredBottle {
                let label = labelInit("有色寶特瓶還可投入：\(coloredBottle)")
                stackView.addArrangedSubview(label)
            }
            
            if let colorlessBottle = machineRemaining.colorlessBottle {
                let label = labelInit("透明寶特瓶還可投入：\(colorlessBottle)")
                stackView.addArrangedSubview(label)
            }
            
            if let can = machineRemaining.can {
                let label = labelInit("鋁罐還可投入：\(can)")
                stackView.addArrangedSubview(label)
            }
            
            if let cup = machineRemaining.cup {
                let label = labelInit("紙杯還可投入：\(cup)")
                stackView.addArrangedSubview(label)
            }
            
            if let hdpeBottle = machineRemaining.hdpeBottle {
                let label = labelInit("牛奶瓶還可投入：\(hdpeBottle)")
                stackView.addArrangedSubview(label)
            }
            
            if let foilPack = machineRemaining.foilPack {
                let label = labelInit("利樂包還可投入：\(foilPack)")
                stackView.addArrangedSubview(label)
            }
            
            if let cartonBox = machineRemaining.cartonBox {
                let label = labelInit("紙盒包還可投入：\(cartonBox)")
                stackView.addArrangedSubview(label)
            }
        }
    }
    
    private func statusRowView() -> UIView {
        let row = UIStackView()
        row.axis = .horizontal
        row.spacing = 4
        row.alignment = .center

        let icon = UIImageView()
        if #available(iOS 13.0, *) {
            icon.image = UIImage(systemName: "exclamationmark.circle.fill")
        }
        icon.tintColor = .systemRed
        icon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            icon.widthAnchor.constraint(equalToConstant: 18),
            icon.heightAnchor.constraint(equalToConstant: 18)
        ])

        let label = UILabel()
        label.font = storeName.font
        label.text = "滿位/維護"
        label.textColor = .systemRed
        label.textAlignment = .center

        row.addArrangedSubview(icon)
        row.addArrangedSubview(label)

        let wrapper = UIView()
        wrapper.addSubview(row)
        row.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            row.centerXAnchor.constraint(equalTo: wrapper.centerXAnchor),
            row.topAnchor.constraint(equalTo: wrapper.topAnchor),
            row.bottomAnchor.constraint(equalTo: wrapper.bottomAnchor)
        ])
        return wrapper
    }

    private func labelInit(_ textCount:String) -> UILabel {
        let label = UILabel()
        label.font = storeName.font
        label.text = textCount
        label.textColor = storeName.textColor
        label.textAlignment = storeName.textAlignment
        return label
    }
}
