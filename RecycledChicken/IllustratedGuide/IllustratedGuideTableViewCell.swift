//
//  IllustratedGuideTableViewCell.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2024/2/25.
//

import UIKit

protocol IllustratedGuideTableViewCellDelegate {
    func tapGesture(_ illustratedGuideTableData:IllustratedGuideTableData)
}

class IllustratedGuideTableViewCell: UITableViewCell {
    
    static let identifier = "IllustratedGuideTableViewCell"
    
    var delegate:IllustratedGuideTableViewCellDelegate?
    
    @IBOutlet weak var content:UIView!
    
    private var guideImageView:UIImageView = {
        let imageView = UIImageView( )
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private var illustratedGuideTableData:IllustratedGuideTableData?
    
    private var scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isScrollEnabled = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

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
        guideImageView.image = nil
    }
    
    func setCell(_ illustratedGuideTableData:IllustratedGuideTableData) {
        self.illustratedGuideTableData = illustratedGuideTableData
        UIInit()
    }
    
    @objc private func tapGesture(_ tap:UITapGestureRecognizer) {
        if checkLevel() {
            delegate?.tapGesture(illustratedGuideTableData!)
            guideImageView.removeFromSuperview()
        }
    }
    
    private func UIInit() {
        guard let illustratedGuideTableData = illustratedGuideTableData else { return }
        let info = illustratedGuideTableData.illustratedGuideInfo.getInfo()
        content.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
        scrollView.centerYAnchor.constraint(equalTo: content.centerYAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: content.widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalToConstant: 110).isActive = true
        
        var contentWith = content.frame.width
    
        let illustratedGuideFirstInfoView = IllustratedGuideFirstInfoView()
        illustratedGuideFirstInfoView.delegate = self
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
        
        illustratedGuideFirstInfoView.setInfo(info.iconImage, name: info.name, type: info.title, guide: String(info.guide.prefix(30)))
        
        if info.guide.count > 30 {
            contentWith += content.frame.width
            illustratedGuideFirstInfoView.rightBtn.isHidden = false
            let illustratedGuideSecondInfoView = IllustratedGuideSecondInfoView()
            illustratedGuideSecondInfoView.delegate = self
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
            let suffixIndex = info.guide.count - 30
            illustratedGuideSecondInfoView.setInfo(info.name, type: info.title, guide: String(info.guide.suffix(suffixIndex)))
        }
        scrollView.contentSize = CGSize(width: contentWith, height: content.frame.size.height)
        
        if !illustratedGuideTableData.isRead {
            guideImageView.image = UIImage(named: "chiw 3")
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapGesture(_:)))
            guideImageView.addGestureRecognizer(tap)
            content.addSubview(guideImageView)
            guideImageView.translatesAutoresizingMaskIntoConstraints = false
            guideImageView.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
            guideImageView.centerYAnchor.constraint(equalTo: content.centerYAnchor).isActive = true
            guideImageView.widthAnchor.constraint(equalTo: illustratedGuideFirstInfoView.widthAnchor).isActive = true
            guideImageView.heightAnchor.constraint(equalTo: illustratedGuideFirstInfoView.heightAnchor).isActive = true
            
            if checkLevel() {
                guideImageView.image = info.guideImage
            }
        }
    }
    
    private func checkLevel() -> Bool {
        guard let illustratedGuideTableData = illustratedGuideTableData else { return false }
        if let profileInfo = CurrentUserInfo.shared.currentProfileInfo, let levelInfo = profileInfo.levelInfo, let level = levelInfo.level, level >= illustratedGuideTableData.illustratedGuideInfo.getInfo().level {
            return true
        }
        return false
    }
    
}

extension IllustratedGuideTableViewCell: IllustratedGuideFirstInfoViewDelegate {
    
    func rightBtnPress(_ sender: UIButton) {
        scrollView.setContentOffset(CGPoint(x: content.frame.width, y: 0), animated: true)
    }
    
}

extension IllustratedGuideTableViewCell: IllustratedGuideSecondInfoViewDelegate {
    
    func leftBtnOnCilck(_ sender: UIButton) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
}
