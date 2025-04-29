//
//  TaskTableSectionView.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2025/4/30.
//

import UIKit

class TaskTableSectionView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var titleLabel: CustomLabel!
    
    func setTitleLabel (_ title:String) {
        titleLabel.text = title
    }
}
