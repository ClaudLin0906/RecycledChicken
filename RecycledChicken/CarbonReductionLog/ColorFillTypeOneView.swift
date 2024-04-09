//
//  ColorFillTypeOneView.swift
//  RecycledChicken
//
//  Created by Claud on 2024/4/3.
//

import UIKit

protocol ColorFillTypeOneViewDelegate {
    func tapImageView(_ svgBackgroundView:UIView, _ imageSVGName:String)
    func tapView(_ v:UIView)
}

class ColorFillTypeOneView: UIView, NibOwnerLoadable {

    
    var delegate:ColorFillTypeOneViewDelegate?
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        sevenCellView.addSVG()
    }
    
    private func customInit(){
        loadNibContent()
        oneCellView.delegate = self
        twoCellView.delegate = self
        threeCellView.delegate = self
        fourCellView.delegate = self
        fiveCellView.delegate = self
        sixCellView.delegate = self
        sevenCellView.delegate = self
        eightCellView.delegate = self
        nineCellView.delegate = self
    }
}

extension ColorFillTypeOneView:ColorFillTypeOneCellViewDelegate {
    
    func tapImageViewHandle(_ svgBackgroundView: UIView, _ imageSVGName: String) {
        delegate?.tapImageView(svgBackgroundView, imageSVGName)
    }
    
    func tapBackgroundHandle(_ backgroundView: UIView) {
        delegate?.tapView(backgroundView)
    }
    
}
