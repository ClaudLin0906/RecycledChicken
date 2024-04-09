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
    
    @IBOutlet weak var oneCellView:SVGImageView!
    
    @IBOutlet weak var twoCellView:SVGImageView!
    
    @IBOutlet weak var threeCellView:SVGImageView!
    
    @IBOutlet weak var fourCellView:SVGImageView!
    
    @IBOutlet weak var fiveCellView:SVGImageView!
    
    @IBOutlet weak var sixCellView:SVGImageView!
    
    @IBOutlet weak var sevenCellView:SVGImageView!
    
    @IBOutlet weak var eightCellView:SVGImageView!
    
    @IBOutlet weak var nineCellView:SVGImageView!
        
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

extension ColorFillTypeOneView:SVGImageViewDelegate {
    
    func tapImageViewHandle(_ svgBackgroundView: UIView, _ imageSVGName: String) {
        delegate?.tapImageView(svgBackgroundView, imageSVGName)
    }
    
    func tapBackgroundHandle(_ backgroundView: UIView) {
        delegate?.tapView(backgroundView)
    }
    
}
