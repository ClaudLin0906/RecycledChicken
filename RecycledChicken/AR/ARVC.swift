//
//  ARVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/11.
//

import UIKit
//import LiGScannerKit
class ARVC: CustomRootVC {

    private var cameraView: CircularCameraView!
    
    @IBOutlet var scannerView: ScannerView!
    
//    let scanner = LiGScanner.sharedInstance()
    var startARView = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit(){
//        scanner.delegate = self
//        cameraView = CircularCameraView()
//        view.addSubview(cameraView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startARView = false
        startScan()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopScan()
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @IBAction func goToProductDescription(_ sender:UIButton) {
        if let navigationController = self.navigationController, let VC = UIStoryboard(name: "ProductDescription", bundle: Bundle.main).instantiateViewController(identifier: "ProductDescription") as? ProductDescriptionVC {
            pushVC(targetVC: VC, navigation: navigationController)
        }
    }
    
    private func startScan() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
//            self.scanner.stop()
//            self.scanner.start()
        }
    }
    
    private func stopScan() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
//            self.scanner.stop()
        }
    }

}

//extension ARVC:LiGScannerDelegate{
//
//    func scannerStatus(_ status: ScannerStatus) {
//        var msg = "Scanner Status: ";
//        switch (status) {
//        case .noCameraPermission:          msg.append("No Camera Permission")
//        case .noNetworkPermission:         msg.append("No Network Permission")
//        case .deviceNotSupported:          msg.append("Device Not Supported")
//        case .configFileError:             msg.append("Config File Error")
//        case .cameraRunningError:          msg.append("Camera Running Error")
//        case .sdkNotSupported:             msg.append("SDK Not Supported")
//        case .sdkUnknow:                   msg.append("SDK Support Unknown")
//        case .authenticationOk:
//            msg.append("Authentication OK\n")
//            let token = scanner.accessToken
//            msg.append("Access Token(\(token.count)) = \(token)")
//        case .authenticationFailed:        msg.append("Authentication Failed")
//        case .authenticationTimeout:       msg.append("Authentication Timeout")
//        case .authenticationInterrupted:   msg.append("Authentication Interrupted")
//        default:                           msg.append("Other Status (\(status.rawValue))")
//        }
//        print(msg)
//    }
//
//    func scannerResult(_ ids: [LightID]) {
//        let count = ids.count
//        if (count > 0) {
//            let lightId = ids[0]
//            scannerView.send(lightId)
//        }
//
//    }
//
//
//}
