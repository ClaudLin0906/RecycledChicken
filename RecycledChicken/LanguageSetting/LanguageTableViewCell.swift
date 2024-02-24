//
//  LanguageTableViewCell.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2024/2/24.
//

import UIKit

class LanguageTableViewCell: UITableViewCell {
    
    static let identifier = "LanguageTableViewCell"
    
    @IBOutlet weak var titleLabel:UILabel!
    
    private var languageType:Language?

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
        backgroundColor = .white
    }
    
    func setCell(_ type:Language) {
        languageType = type
        titleLabel.text = type.rawValue
        if Setting.shared.language == languageType {
            backgroundColor = #colorLiteral(red: 0.9450980392, green: 0.8784313725, blue: 0.7960784314, alpha: 1)
        }
    }

}
