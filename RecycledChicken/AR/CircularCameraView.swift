//
//  CircularCameraView.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/6/3.
//

import UIKit
import AVFoundation

class CircularCameraView: UIView {
    
    private let captureSession = AVCaptureSession()
    private let previewLayer = AVCaptureVideoPreviewLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }
    
    private func customInit(){
        configureCameraView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer.frame = bounds
        layer.cornerRadius = bounds.width / 2  // 設定圓角半徑為視圖寬度的一半
        layer.masksToBounds = true
    }
    
    private func configureCameraView() {
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
            
            previewLayer.session = captureSession
            previewLayer.videoGravity = .resizeAspectFill
            layer.addSublayer(previewLayer)
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.captureSession.startRunning()
            }
            
        } catch {
            print("Error setting up camera input: \(error.localizedDescription)")
        }
    }
    

}
