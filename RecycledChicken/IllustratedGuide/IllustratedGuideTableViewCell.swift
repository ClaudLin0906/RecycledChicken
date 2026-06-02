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
    
    @IBOutlet weak var guideOverlayView:GuideOverlayView!
    
    private var illustratedGuideTableData:IllustratedGuideTableData?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        illustratedGuideImageView.image = nil
    }
    
    func setCell(_ illustratedGuideTableData:IllustratedGuideTableData) {
        self.illustratedGuideTableData = illustratedGuideTableData
        illustratedGuideImageView.image = getIllustratedGuide(illustratedGuideTableData.illustratedGuideModelLevel).guideImage
        guideOverlayView.setGuideImageView(isVisible: !illustratedGuideTableData.isRead)
    }
    
}
