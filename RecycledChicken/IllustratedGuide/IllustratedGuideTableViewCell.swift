//
//  IllustratedGuideTableViewCell.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2024/2/25.
//

import UIKit

class IllustratedGuideTableViewCell: UITableViewCell {
    
    static let identifier = "IllustratedGuideTableViewCell"
    
    private var illustratedGuide:IllustratedGuide?
    
    @IBOutlet weak var content:UIView!

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
    
    private func UIInit() {
        guard let illustratedGuide = illustratedGuide else { return }
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
//        scrollView.isScrollEnabled = false
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
        
        if illustratedGuide.guide.count <= 30 {
            illustratedGuideFirstInfoView.setInfo(illustratedGuide.iconImage, name: illustratedGuide.name, type: illustratedGuide.title, guide: String(illustratedGuide.guide.prefix(30)))
        }
        
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
            illustratedGuideSecondInfoView.setInfo(illustratedGuide.name, type: illustratedGuide.title, guide: String(illustratedGuide.guide.suffix(30)))
        }
        
        scrollView.contentSize = CGSize(width: contentWith, height: content.frame.size.height)

        if checkLevel() {
            
        }

    }
    
    private func checkLevel() -> Bool {
        guard let illustratedGuide = illustratedGuide else { return false }
        if let profileInfo = CurrentUserInfo.shared.currentProfileInfo, let levelInfo = profileInfo.levelInfo, let level = levelInfo.level, level >= illustratedGuide.level {
            return true
        }
        return false
    }
    

}
