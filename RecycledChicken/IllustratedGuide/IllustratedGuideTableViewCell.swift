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
    
    @IBOutlet weak var illustratedGuideImageView:UIImageView!
    
    private var guideImageView:UIImageView = {
        let imageView = UIImageView( )
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "chiw 3")
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
    }
    
    func setCell(_ illustratedGuideTableData:IllustratedGuideTableData) {
        self.illustratedGuideTableData = illustratedGuideTableData
        illustratedGuideImageView.image = getIllustratedGuide(illustratedGuideTableData.illustratedGuideModelLevel).guideImage
        setGuideImageView()
    }
    
    private func setGuideImageView() {
        guard let illustratedGuideTableData = illustratedGuideTableData else { return }
        if !illustratedGuideTableData.isRead {
            illustratedGuideImageView.addSubview(guideImageView)
            guideImageView.centerXAnchor.constraint(equalTo: illustratedGuideImageView.centerXAnchor).isActive = true
            guideImageView.centerYAnchor.constraint(equalTo: illustratedGuideImageView.centerYAnchor).isActive = true
            guideImageView.widthAnchor.constraint(equalTo: illustratedGuideImageView.widthAnchor).isActive = true
            guideImageView.heightAnchor.constraint(equalTo: illustratedGuideImageView.heightAnchor).isActive = true
        }
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
