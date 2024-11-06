//
//  ColoringTutorialVideoView.swift
//  RecycledChicken
//
//  Created by sj on 2024/11/7.
//

import UIKit
import AVFoundation
import AVKit

class ColoringTutorialVideoView: UIView, NibOwnerLoadable {
    
    var player: AVPlayer?
    
    var playerLayer: AVPlayerLayer?
    
    @IBOutlet weak var playerView:UIView!

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
        playerLayer?.frame = playerView.frame
    }
    
    @IBAction func close(_ sender:UIButton) {
        self.removeFromSuperview()
    }
    
    private func customInit(){
        loadNibContent()
        guard let videoURL = Bundle.main.url(forResource: "ColoringTutorialVideo", withExtension: "mp4") else {
            return
        }
        player = AVPlayer(url: videoURL)
        playerLayer = AVPlayerLayer(player: player)
        layer.addSublayer(playerLayer!)
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { [weak self] _ in
            self?.player?.seek(to: CMTime.zero)
            self?.player?.play()
        }
        player?.play()
    }
}
