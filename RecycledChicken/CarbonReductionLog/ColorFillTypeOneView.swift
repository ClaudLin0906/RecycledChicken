//
//  ColorFillTypeOneView.swift
//  RecycledChicken
//
//  Created by Claud on 2024/4/3.
//

import UIKit

class ColorFillTypeOneView: UIView, NibOwnerLoadable {
    
    var delegate:ColorFillTypeDelegate?
    
    var colorFillView:ColorFillView = .ColorFillTypeOneView
    
    @IBOutlet weak var oneCellView:ColorFillTypeOneCellView!
    
    @IBOutlet weak var twoCellView:ColorFillTypeOneCellView!
    
    @IBOutlet weak var threeCellView:ColorFillTypeOneCellView!
    
    @IBOutlet weak var fourCellView:ColorFillTypeOneCellView!
    
    @IBOutlet weak var fiveCellView:ColorFillTypeOneCellView!
    
    @IBOutlet weak var sixCellView:ColorFillTypeOneCellView!
    
    @IBOutlet weak var sevenCellView:ColorFillTypeOneCellView!
    
    @IBOutlet weak var eightCellView:ColorFillTypeOneCellView!
    
    @IBOutlet weak var nineCellView:ColorFillTypeOneCellView!
    
    private lazy var colorFillTypeOneCellViews:[ColorFillTypeOneCellView] = [oneCellView, twoCellView, threeCellView, fourCellView, fiveCellView, sixCellView, sevenCellView, eightCellView, nineCellView]
                
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
        colorFillTypeOneCellViews.forEach({$0.delegate = self})
    }
}

extension ColorFillTypeOneView:ColorFillTypeOneCellViewDelegate {
    
    func tapImageViewHandle(_ imageView: UIImageView, userdefultKey: String) {
        delegate?.tapImage(imageView, userdefultKey: userdefultKey, colorFillView: colorFillView)
    }
    
    func tapBackgroundHandle(_ backgroundView: UIView, userdefultKey: String) {
        delegate?.tapBackground(backgroundView, userdefultKey: userdefultKey, colorFillView: colorFillView)
    }
    
}
