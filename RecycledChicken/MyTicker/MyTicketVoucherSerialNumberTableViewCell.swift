//
//  MyTicketVoucherSerialNumberTableViewCell.swift
//  RecycledChicken
//
//  Created by Claud on 2024/3/14.
//

import UIKit

class MyTicketVoucherSerialNumberTableViewCell: UITableViewCell {
    
    static let identifier = "MyTicketVoucherSerialNumberTableViewCell"
    
    @IBOutlet weak var itemImageView: UIImageView!
    
    @IBOutlet weak var serialNumberLabel:UILabel!
    
    @IBOutlet weak var itemNameLabel: CustomLabel!
    
    @IBOutlet weak var duringTimeLabel: CustomLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(_ info:MyTickertCouponsInfo) {
        
    }

}
