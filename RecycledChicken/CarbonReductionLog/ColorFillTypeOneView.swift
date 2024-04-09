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
    
    @IBOutlet weak var oneCellView:UIView!
    
    @IBOutlet weak var twoCellView:UIView!
    
    @IBOutlet weak var threeCellView:UIView!
    
    @IBOutlet weak var fourCellView:UIView!
    
    @IBOutlet weak var fiveCellView:UIView!
    
    @IBOutlet weak var sixCellView:UIView!
    
    @IBOutlet weak var sevenCellView:SVGImageView!
    
    @IBOutlet weak var eightCellView:UIView!
    
    @IBOutlet weak var nineCellView:UIView!
    
    private lazy var cellViews:[UIView] = [oneCellView, twoCellView, threeCellView, fourCellView, fiveCellView, sixCellView, eightCellView, nineCellView]
        
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
        sevenCellView.delegate = self
        cellViews.forEach({addBtn($0)})
    }
    
    private func addBtn(_ targetView:UIView) {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(btnOnClick(_:)), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        targetView.addSubview(btn)
        btn.centerXAnchor.constraint(equalTo: targetView.centerXAnchor).isActive = true
        btn.centerYAnchor.constraint(equalTo: targetView.centerYAnchor).isActive = true
        btn.widthAnchor.constraint(equalTo: targetView.widthAnchor).isActive = true
        btn.heightAnchor.constraint(equalTo: targetView.heightAnchor).isActive = true
    }
    
    @objc private func btnOnClick(_ sender:UIButton) {
        if let targetView = cellViews.first(where: {sender.superview == $0}) {
            delegate?.tapView(targetView)
        }
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
