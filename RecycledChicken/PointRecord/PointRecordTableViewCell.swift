//
//  PointRecordTableViewCell.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2024/2/25.
//

import UIKit

class PointRecordTableViewCell: UITableViewCell {
    
    static let identifier = "PointRecordTableViewCell"
    
    @IBOutlet weak var calendarLabel:UILabel!
    
    @IBOutlet weak var contentLabel:UILabel!
    
    @IBOutlet weak var pointLabel:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(_ date:Date, content:String, point:Int) {
        calendarLabel.text = getDates(i: 0, currentDate: date).0
        contentLabel.text = content
        pointLabel.text = String(point)
        setPointLabelTextColor()
    }
    
    func setPointLabelTextColor() {
        let count = Int(pointLabel.text ?? "0") ?? 0
        if count < 0 {
            pointLabel.textColor = #colorLiteral(red: 1, green: 0.2698960602, blue: 0.217741549, alpha: 1)
        }
        if count >= 0 {
            pointLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }

}
