import UIKit
import ARKit
import SceneKit
//import LiGScannerKit

class ARViewController: CustomVC, ARSCNViewDelegate, ARSessionDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    @IBOutlet var backButton: UIButton!

    var sceneWorldOriginTransform = matrix_float4x4()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        sceneView.delegate = self
        sceneView.session.delegate = self
        sceneView.showsStatistics = true
        sceneView.debugOptions = [.showWorldOrigin]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultNavigationBackBtn()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let config = ARWorldTrackingConfiguration()
        config.isAutoFocusEnabled = false
        sceneView.session.run(config, options: .resetTracking)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        sceneView.session.pause()
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
//        LiGScanner.sharedInstance().calibration(frame.camera)
    }
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        switch camera.trackingState {
        case .normal:
            session.setWorldOrigin(relativeTransform: sceneWorldOriginTransform)
        default:
            NSLog("do nothing")
        }
    }
}
