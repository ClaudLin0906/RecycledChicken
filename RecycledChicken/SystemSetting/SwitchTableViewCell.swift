//
//  SwitchTableViewCell.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/10.
//

import UIKit

protocol SwitchTableViewCellDelegate {
    func changeStatus(_ sender:UISwitch, tag:Int)
}

class SwitchTableViewCell: UITableViewCell {
    
    static let identifier = "SwitchTableViewCell"
    
    var delegate:SwitchTableViewCellDelegate?
    
    @IBOutlet weak var title:UILabel!
    
    @IBOutlet weak var turnOnOff:UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
        turnOnOff.addTarget(self, action: #selector(changeStatus(_:)), for: .valueChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setCell(_ info:switchTableViewInfo) {
        title.text = info.title
        turnOnOff.isOn = info.isTrue
    }
    
    @objc private func changeStatus(_ sender:UISwitch){
        delegate?.changeStatus(sender, tag: tag)
    }

}
