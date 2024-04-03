//
//  ColorFillTypeOneView.swift
//  RecycledChicken
//
//  Created by Claud on 2024/4/3.
//

import UIKit

class ColorFillTypeOneView: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var oneCellView:ColorFillTypeOneCellView!
    
    @IBOutlet weak var twoCellView:ColorFillTypeOneCellView!
    
    @IBOutlet weak var threeCellView:ColorFillTypeOneCellView!
    
    @IBOutlet weak var fourCellView:ColorFillTypeOneCellView!
    
    @IBOutlet weak var fiveCellView:ColorFillTypeOneCellView!
    
    @IBOutlet weak var sixCellView:ColorFillTypeOneCellView!
    
    @IBOutlet weak var sevenCellView:ColorFillTypeOneCellView!
    
    @IBOutlet weak var eightCellView:ColorFillTypeOneCellView!
    
    @IBOutlet weak var nineCellView:ColorFillTypeOneCellView!
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }
    
    private func customInit(){
        loadNibContent()
    }
}
