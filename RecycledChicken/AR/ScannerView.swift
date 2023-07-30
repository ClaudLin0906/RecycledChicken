import Foundation
import UIKit
import LiGScannerKit

class CycleView : UIView {
    
    let radius: Double = 24
    let labelView = UILabel()
    
    var text = "" {
        didSet {
            labelView.text = text
        }
    }
    
    var textHidden = false {
        didSet {
            
            labelView.isHidden = textHidden
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        prepare()
    }
    
    func prepare() {
        
        // init cycle view
        clipsToBounds = true
        layer.cornerRadius = CGFloat(radius)
        backgroundColor = .clear
        isOpaque = false
        self.frame.size = CGSize(width: radius * 2, height: radius * 2)
        
        // init label view
        labelView.isHidden = true
        labelView.textColor = .red
        labelView.textAlignment = .center
        labelView.numberOfLines = 0
        labelView.frame.size = CGSize(width: radius * 3, height: radius * 3)
        labelView.center = CGPoint(x: radius, y: radius)
        addSubview(labelView)
    }
}

class ScannerView : UIView {
    
    let cycleView = CycleView()
    
    func prepare() {
        addSubview(cycleView)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        prepare()
    }
    
    override func draw(_ rect: CGRect) {
        if let context = UIGraphicsGetCurrentContext() {
            context.setStrokeColor(CGColor(red: 1, green: 1, blue: 1, alpha: 1))
            context.setLineWidth(2.0)
            let windowWidth = frame.size.width
            let windowHeight = frame.size.height
            let frameRect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: windowWidth, height: windowHeight))
            context.stroke(frameRect)
            let areaWidth = windowWidth / 4
            let areaHeight = windowHeight / 4
            let areaCenter = CGPoint(x: (windowWidth - areaWidth) / 2, y: (windowHeight - areaHeight) / 2)
            let areaRect = CGRect(origin: areaCenter, size: CGSize(width: areaWidth, height: areaHeight))
            context.stroke(areaRect)
        }
    }
    
    func send(_ lightID: LightID) {
    
        DispatchQueue.main.async {

            let windowWidth = Float(self.frame.size.width)
            let windowHeight = Float(self.frame.size.height.native)
            let aimPosX = CGFloat(windowWidth * lightID.coordinateX)
            let aimPosY = CGFloat(windowHeight * lightID.coordinateY)
            
            if lightID.isDetected {
                self.cycleView.text = String(lightID.deviceId)
                self.cycleView.textHidden = false
            } else {
                self.cycleView.text = ""
                self.cycleView.textHidden = true
            }
            
            if lightID.isReady {
                self.cycleView.backgroundColor = .green
            } else {
                self.cycleView.backgroundColor = .yellow
            }
            
            self.cycleView.center.x = aimPosX
            self.cycleView.center.y = aimPosY
        }
    }
}
