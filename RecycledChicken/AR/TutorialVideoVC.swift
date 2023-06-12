//
//  TutorialVideoVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/6/12.
//

import UIKit
import AVFoundation
import AVKit
class TutorialVideoVC: UIViewController {
    
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    private func UIInit(){
        // 获取视频文件的URL
        guard let videoURL = Bundle.main.url(forResource: "TutorialVideo", withExtension: "mp4") else {
            return
        }

        // 创建AVPlayer对象
        player = AVPlayer(url: videoURL)

        // 创建AVPlayerLayer对象用于显示视频
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = view.bounds
        view.layer.addSublayer(playerLayer!)

        // 播放视频
        player?.play()
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // 更新AVPlayerLayer的frame
        playerLayer?.frame = view.bounds
    }
}
