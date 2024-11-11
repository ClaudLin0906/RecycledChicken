//
//  ProductDescriptionVC.swift
//  RecycledChicken
//
//  Created by Claud on 2023/5/12.
//

import UIKit
import AVFoundation
import AVKit
class ProductDescriptionVC: CustomVC {
    
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "操作說明"
        UIInit()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultNavigationBackBtn2()
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // 更新AVPlayerLayer的frame
        playerLayer?.frame = view.safeAreaLayoutGuide.layoutFrame
    }
    
    private func UIInit(){
        // 获取视频文件的URL
        guard let videoURL = Bundle.main.url(forResource: "ColoringTutorialVideo", withExtension: "mp4") else {
            return
        }

        // 创建AVPlayer对象
        player = AVPlayer(url: videoURL)

        // 创建AVPlayerLayer对象用于显示视频
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = view.safeAreaLayoutGuide.layoutFrame
        view.layer.addSublayer(playerLayer!)
        
        // 循环播放视频
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { [weak self] _ in
            self?.player?.seek(to: CMTime.zero)
            self?.player?.play()
        }

        // 播放视频
        player?.play()
    }

}
