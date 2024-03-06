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
    
    private lazy var guideImageView:UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "chiw 3"))
        imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGesture(_:)))
        imageView.addGestureRecognizer(tap)
        return imageView
    }()
    
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
    }
    
    func setCell(_ illustratedGuide:IllustratedGuide) {
        self.illustratedGuide = illustratedGuide
        UIInit()
    }
    
    @objc private func tapGesture(_ tap:UITapGestureRecognizer) {
        guideImageView.removeFromSuperview()
    }
    
    private func UIInit() {
        guard let illustratedGuide = illustratedGuide else { return }
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isScrollEnabled = false
        content.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
        scrollView.centerYAnchor.constraint(equalTo: content.centerYAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: content.widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: content.heightAnchor).isActive = true
        
        var contentWith = content.frame.width
    
        let illustratedGuideFirstInfoView = IllustratedGuideFirstInfoView()
        illustratedGuideFirstInfoView.backgroundColor = .white
        illustratedGuideFirstInfoView.layer.cornerRadius = 10
        illustratedGuideFirstInfoView.layer.shadowOffset = CGSize(width: 1, height: 1)
        illustratedGuideFirstInfoView.layer.shadowOpacity = 0.4
        scrollView.addSubview(illustratedGuideFirstInfoView)
        illustratedGuideFirstInfoView.translatesAutoresizingMaskIntoConstraints = false
        illustratedGuideFirstInfoView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        illustratedGuideFirstInfoView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor).isActive = true
        illustratedGuideFirstInfoView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -20).isActive = true
        illustratedGuideFirstInfoView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, constant: -15).isActive = true
        
        illustratedGuideFirstInfoView.setInfo(illustratedGuide.iconImage, name: illustratedGuide.name, type: illustratedGuide.title, guide: String(illustratedGuide.guide.prefix(30)))
        
        let leftGesture = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipeGesture(_:)))
        leftGesture.direction = .left
        illustratedGuideFirstInfoView.addGestureRecognizer(leftGesture)
        if illustratedGuide.guide.count > 30 {
            contentWith += content.frame.width
            let illustratedGuideSecondInfoView = IllustratedGuideSecondInfoView()
            illustratedGuideSecondInfoView.backgroundColor = .white
            illustratedGuideSecondInfoView.layer.cornerRadius = 10
            illustratedGuideSecondInfoView.layer.shadowOffset = CGSize(width: 1, height: 1)
            illustratedGuideSecondInfoView.layer.shadowOpacity = 0.4
            scrollView.addSubview(illustratedGuideSecondInfoView)
            illustratedGuideSecondInfoView.translatesAutoresizingMaskIntoConstraints = false
            illustratedGuideSecondInfoView.leadingAnchor.constraint(equalTo: illustratedGuideFirstInfoView.trailingAnchor, constant: 20).isActive = true
            illustratedGuideSecondInfoView.centerYAnchor.constraint(equalTo: illustratedGuideFirstInfoView.centerYAnchor).isActive = true
            illustratedGuideSecondInfoView.widthAnchor.constraint(equalTo: illustratedGuideFirstInfoView.widthAnchor).isActive = true
            illustratedGuideSecondInfoView.heightAnchor.constraint(equalTo: illustratedGuideFirstInfoView.heightAnchor).isActive = true
            let suffixIndex = illustratedGuide.guide.count - 30
            illustratedGuideSecondInfoView.setInfo(illustratedGuide.name, type: illustratedGuide.title, guide: String(illustratedGuide.guide.suffix(suffixIndex)))
        }
        scrollView.contentSize = CGSize(width: contentWith, height: content.frame.size.height)

        content.addSubview(guideImageView)
        guideImageView.translatesAutoresizingMaskIntoConstraints = false
        guideImageView.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
        guideImageView.centerYAnchor.constraint(equalTo: content.centerYAnchor).isActive = true
        guideImageView.widthAnchor.constraint(equalTo: content.widthAnchor).isActive = true
        guideImageView.heightAnchor.constraint(equalTo: content.heightAnchor).isActive = true
        
        if checkLevel() {
            guideImageView.image = illustratedGuide.guideImage
        }

    }
    
    @objc private func leftSwipeGesture(_ swipe:UISwipeGestureRecognizer) {
        print("1231")
    }
    
    private func checkLevel() -> Bool {
        guard let illustratedGuide = illustratedGuide else { return false }
        if let profileInfo = CurrentUserInfo.shared.currentProfileInfo, let levelInfo = profileInfo.levelInfo, let level = levelInfo.level, level >= illustratedGuide.level {
            return true
        }
        return false
    }
    

}
