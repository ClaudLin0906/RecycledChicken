//
//  StoreListTableViewCell.swift
//  RecycledChicken
//
//  Created by Claud on 2023/5/12.
//

import UIKit

class StoreListTableViewCell: UITableViewCell {
    
    static let identifier = "StoreListTableViewCell"
    
    @IBOutlet weak var storeName:CustomLabel!
    
    @IBOutlet weak var storeAddress:CustomLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(mapInfo:MapInfo){
        storeName.text = mapInfo.name
        storeAddress.text = mapInfo.address
    }

}
