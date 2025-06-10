//
//  PersonMessageTableViewCell.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/9.
//

import UIKit

protocol PersonMessageTableViewCellDelegate {
    func tapDeleteViewPress(_ indexPath:IndexPath)
}

class PersonMessageTableViewCell: UITableViewCell {
    
    static let identifier = "PersonMessageTableViewCell"
    
    var delegate:PersonMessageTableViewCellDelegate?
    
    @IBOutlet weak var titleLabel:CustomLabel!
    
    @IBOutlet weak var timeLabel:CustomLabel!
    
    @IBOutlet weak var infoContentView:UIView!
    
    private var personMessageInfo:PersonMessageInfo?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGes(_:)))
        addGestureRecognizer(longPress)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        personMessageInfo = nil
        self.subviews.forEach { subview in
            if subview is DeleteMessageAlertView {
                subview.removeFromSuperview()
            }
        }
    }
    
    func setCell(_ personMessageInfo:PersonMessageInfo) {
        self.personMessageInfo = personMessageInfo
        titleLabel.text = "\(personMessageInfo.title ?? "")"
        if let createTime = personMessageInfo.createTime, let date = dateFromString(createTime) {
            let dateStr = getDates(i: 0, currentDate: date).0
            timeLabel.text = dateStr
        }
        if personMessageInfo.isShowDeleteView {
            showDeleteView()
        }
    }

    @objc private func longPressGes(_ longPress:UILongPressGestureRecognizer) {
        personMessageInfo?.isShowDeleteView = true
    }
    
    func showDeleteView() {
        let deleteMessageAlertView = DeleteMessageAlertView(frame: infoContentView.frame)
        deleteMessageAlertView.alpha = 0.0 // Start with view invisible
        addSubview(deleteMessageAlertView)
        UIView.animate(withDuration: 0.3) {
            deleteMessageAlertView.alpha = 1.0
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapDeleteView(_:)))
        deleteMessageAlertView.addGestureRecognizer(tap)
    }
    
    @objc private func tapDeleteView(_ tap:UITapGestureRecognizer) {
        if let indexPath = indexPath {
            delegate?.tapDeleteViewPress(indexPath)
        }
    }
    
}
