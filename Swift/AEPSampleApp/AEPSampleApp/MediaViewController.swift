/*
Copyright 2020 Adobe. All rights reserved.
This file is licensed to you under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License. You may obtain a copy
of the License at http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under
the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR REPRESENTATIONS
OF ANY KIND, either express or implied. See the License for the specific language
governing permissions and limitations under the License.
*/

import Foundation
import UIKit
import AVKit

class MediaViewController: UIViewController {
    let TIME_CONTROL_STATUS_KEY = "timeControlStatus"
    let PLAYER_ENDED_PLAYING_NOTIFICATION = "AVPlayerItemDidPlayToEndTimeNotification"
    
//    var mediaTracker: ACPMediaTracker? = nil
    var player: AVPlayer? = nil
    var playerVC: AVPlayerViewController? = nil
    var playButton: UIButton = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupButton()
        setupPlayer()
    }
    
    private func setupButton() {
        playButton.setTitle("Play", for: .normal)
        playButton.backgroundColor = .gray
        playButton.setTitleColor(.white, for: .normal)
        let buttonWidth: CGFloat = 100.0
        var centerOrigin = self.view.center
        let centerX = centerOrigin.x - buttonWidth/2
        centerOrigin.x = centerX
        playButton.frame = CGRect(origin: centerOrigin, size: CGSize(width: buttonWidth, height: buttonWidth/2))
        playButton.addTarget(self, action: #selector(playVideoButtonTapped(_:)), for: .touchUpInside)
        self.view.addSubview(playButton)
    }
    
    private func setupPlayer() {
        guard let url = Bundle.main.url(forResource: "testVideo", withExtension: "mp4") else {
            return
        }
        let asset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        self.player = AVPlayer(playerItem: playerItem)
        self.player?.addObserver(self, forKeyPath: TIME_CONTROL_STATUS_KEY, options: [.old, .new], context: nil)
        self.playerVC = AVPlayerViewController()
        playerVC?.player = player
        // Sample Config
        //        var config: [String: Any] = [:]
        //        config[ACPMediaKeyConfigChannel] = "custom-channel"
        //        config[ACPMediaKeyConfigDownloadedContent] = false
        //        // Create the tracker with the custom configuration
        //        ACPMedia.createTracker(withConfig: config, callback: { [weak self] tracker in
        //            self?.mediaTracker = tracker
        //        })
        
        // Notification which tracks when the video has ended playing
        NotificationCenter.default.addObserver(self, selector: #selector(playerEndedPlaying), name: Notification.Name(rawValue: PLAYER_ENDED_PLAYING_NOTIFICATION), object: nil)
    }

    @objc private func playVideoButtonTapped(_ sender: Any) {
        
        present(playerVC!, animated: true) { [weak self] in
            self?.player?.play()
            // Track video play
            // TODO: Queue if media tracker is nil
//            self?.mediaTracker?.trackPlay()
        }

    }
    
    @objc func playerEndedPlaying(_ notification: Notification) {
        // TODO: Queue if media tracker is nil
//        self.mediaTracker?.trackComplete()
    }

    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // Observe when the status (pause, play, waiting for buffering) changes
        if keyPath == TIME_CONTROL_STATUS_KEY, let change = change, let newValue = change[NSKeyValueChangeKey.newKey] as? Int, let oldValue = change[NSKeyValueChangeKey.oldKey] as? Int {
            let oldStatus = AVPlayer.TimeControlStatus(rawValue: oldValue)
            let newStatus = AVPlayer.TimeControlStatus(rawValue: newValue)
            if newStatus != oldStatus {
                DispatchQueue.main.async { 
                    // Handle the status change here
                    if newStatus == AVPlayer.TimeControlStatus.paused {
//                        self?.mediaTracker?.trackPause()
                    } else if newStatus == AVPlayer.TimeControlStatus.playing {
//                        self?.mediaTracker?.trackPlay()
                    }
                }
            }
        }
    }
    
}


