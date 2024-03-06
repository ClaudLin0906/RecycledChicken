//
//  IllustratedGuideTableViewCell.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2024/2/25.
//

import UIKit

class IllustratedGuideTableViewCell: UITableViewCell {
    
    static let identifier = "IllustratedGuideTableViewCell"
    
    @IBOutlet weak var content:UIView!
    
    private var illustratedGuide:IllustratedGuide?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        content.subviews.forEach({$0.removeFromSuperview()})
    }
    
    func setCell(_ illustratedGuide:IllustratedGuide) {
        self.illustratedGuide = illustratedGuide
        UIInit()
    }
    
    private func UIInit() {
        if let illustratedGuide = illustratedGuide {
            
            if illustratedGuide.isLock {
                addLockImageView()
            }
            
            if !illustratedGuide.isLock {
                addInfoScrollView()
            }
            
        }
    }
    
    func addLockImageView() {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "chiw 3")
        content.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: content.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: content.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: content.heightAnchor).isActive = true
    }
    
    func addInfoScrollView() {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        let tinColor = #colorLiteral(red: 0.6747780442, green: 0.6747780442, blue: 0.6747780442, alpha: 1)
        btn.tintColor = tinColor
        content.addSubview(btn)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.trailingAnchor.constraint(equalTo: content.trailingAnchor).isActive = true
        btn.centerYAnchor.constraint(equalTo: content.centerYAnchor).isActive = true
        btn.heightAnchor.constraint(equalTo: content.heightAnchor).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        let scrollView = UIScrollView()
        content.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: content.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: btn.leadingAnchor, constant: -5).isActive = true
        scrollView.centerYAnchor.constraint(equalTo: content.centerYAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: content.heightAnchor).isActive = true
        
        let illustratedGuideFirstInfoView = IllustratedGuideFirstInfoView()
        scrollView.addSubview(illustratedGuideFirstInfoView)
        illustratedGuideFirstInfoView.translatesAutoresizingMaskIntoConstraints = false
        illustratedGuideFirstInfoView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor).isActive = true
        illustratedGuideFirstInfoView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        illustratedGuideFirstInfoView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        illustratedGuideFirstInfoView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        if let info = illustratedGuide {
            illustratedGuideFirstInfoView.setInfo(info.image, name: info.name, type: info.title, guide: "")
        }
    }

}
