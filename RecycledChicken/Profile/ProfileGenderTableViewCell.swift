//
//  ProfileGenderTableViewCell.swift
//  RecycledChicken
//
//  Created by Antigravity on 2026/06/03.
//

import UIKit

class ProfileGenderTableViewCell: UITableViewCell {
    
    static let identifier = "ProfileGenderTableViewCell"
    
    @IBOutlet weak var infoTitle: UILabel!
    
    @IBOutlet weak var genderSelectionView: GenderSelectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
