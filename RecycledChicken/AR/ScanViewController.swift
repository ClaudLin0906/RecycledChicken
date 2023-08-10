import UIKit
import LiGScannerKit

class ScanViewController: CustomVC, LiGScannerDelegate {
    @IBOutlet var scannerView: ScannerView!
    
    let scanner = LiGScanner.sharedInstance()
    
    func startScan() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.scanner.stop()
            self.scanner.start()
        }
    }
    
    func stopScan() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.scanner.stop()
        }
    }
    
    override open var shouldAutorotate: Bool {
        return false
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isIdleTimerDisabled = true
        scanner.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultNavigationBackBtn()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startScan()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopScan()
    }

    func scannerStatus(_ status: ScannerStatus) {

        var msg = "Scanner Status: ";
        switch (status) {
        case .noCameraPermission:          msg.append("No Camera Permission")
        case .noNetworkPermission:         msg.append("No Network Permission")
        case .deviceNotSupported:          msg.append("Device Not Supported")
        case .configFileError:             msg.append("Config File Error")
        case .cameraRunningError:          msg.append("Camera Running Error")
        case .sdkNotSupported:             msg.append("SDK Not Supported")
        case .sdkUnknow:                   msg.append("SDK Support Unknown")
        case .authenticationOk:
            msg.append("Authentication OK\n")
            let token = scanner.accessToken
            msg.append("Access Token(\(token.count)) = \(token)")
        case .authenticationFailed:        msg.append("Authentication Failed")
        case .authenticationTimeout:       msg.append("Authentication Timeout")
        case .authenticationInterrupted:   msg.append("Authentication Interrupted")
        default:                           msg.append("Other Status (\(status.rawValue))")
        }
    }

    func updateLightIDMessage(_ id: LightID) {

        var text = ""

        var status = ""
        switch (id.status) {
        case .ready:                        status = "READY"
        case .notDetected:                  status = "NOT_DETECTED"
        case .notDecoded:                   status = "NOT_DECODED"
        case .invalidPosition:              status = "INVALID_POSITION"
        case .notRegistered:                status = "NOT_REGISTERED"
        case .invalidPositionTooClose:      status = "INVALID_POSITION_TOO_CLOSE"
        case .distanceRangeRestrictionNear: status = "DISTANCE_RANGE_RESTRICTION_NEAR"
        case .distanceRangeRestrictionFar:  status = "DISTANCE_RANGE_RESTRICTION_FAR"
        case .invalidPositionUnknown:       status = "INVALID_POSITION_UNKNOWN"
        default:                            status = "UNKNOWN ENUM VALUE (\(id.status.rawValue)"
        }

        text.append(contentsOf: "Status: \(status)\n")
        text.append(String(format: "Coordinate: [ %.2f, %.2f ]\n", id.coordinateX, id.coordinateY))

        if (id.isDetected) {
            text.append(String(format: "Detection: %.2f ms\n", id.detectionTime))
            text.append(String(format: "Decoded: %.2f ms\n", id.decodedTime))
        }

        if (id.isReady) {
            text.append(String(format: "Rotation: [ %.2f, %.2f, %.2f ]\n", id.rotation.x, id.rotation.y, id.rotation.z))
            text.append(String(format: "Translation: [ %.2f, %.2f, %.2f ]\n", id.translation.x / 1000, id.translation.y / 1000, id.translation.z / 1000))
            text.append(String(format: "Position: [ %.2f, %.2f, %.2f ]", id.position.x / 1000, id.position.y / 1000, id.position.z / 1000))
        }

    }
    
    func scannerResult(_ ids: [LightID]) {
        let count = ids.count
        if (count > 0) {
            let lightId = ids[0]
            updateLightIDMessage(lightId)
            scannerView.send(lightId)
            
            // go to AR scene
            if lightId.isReady {
                // stop scan and enter a AR page
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    if let navigationController = self.navigationController, let VC = UIStoryboard(name: "ARViewController", bundle: Bundle.main).instantiateViewController(identifier: "ARViewController") as? ARViewController {
                        VC.sceneWorldOriginTransform = lightId.transform
                        self.stopScan()
                        pushVC(targetVC: VC, navigation: navigationController)
                    }
                }
            }
        }
    }
}
