//
//  BeleefDeLenteView.swift
//  BeleefDeLente
//
//  Created by Jeroen Wesbeek on 3/17/16.
//  Copyright © 2016 Jeroen Wesbeek. All rights reserved.
//

import Foundation
import ScreenSaver
import AVKit
import AVFoundation

@objc(BeleefDeLenteView) class BeleefDeLenteView: ScreenSaverView {
    private var birds: [Bird]?
    
    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        
        playVideo()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func playVideo() {
        NSLog("play video")
        NSLog("henk!")
        
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self)
        
        APIManager.sharedInstance.getBirds() { [weak self] birds, error in
            self?.birds = birds
            
//            NSLog("fetched \(birds?.count) birds")
            NSLog("first bird: \(birds?.first?.name)")
            NSLog("got \(birds?.first?.cameras?.count) cameras")
            
            
            
            
            guard let camera = birds?.first?.cameras?.first else {
                NSLog("no camera")
                return
            }
            
            NSLog("got a camera")
            
            camera.getStreamURL() { streamURL, error in
                NSLog("got a stream url?")
                guard let streamURL = streamURL, bounds = self?.bounds else {
                    NSLog("got error \(error)")
                    return
                }
                
                NSLog(streamURL.URLString)
                
                //let url = NSURL(string: "http://a1.phobos.apple.com/us/r1000/000/Features/atv/AutumnResources/videos/b1-1.mov")!
                
                let player = AVPlayer(URL: streamURL)
                if player.rate == 0 {
                    player.play()
                }
                
                let playerLayer = AVPlayerLayer(player: player)
                playerLayer.frame = bounds
                
                guard let currentItem = player.currentItem, this = self else {
                    NSLog("Aerial Error: No current item!")
                    return
                }
                
//                notificationCenter.addObserver(this, selector: "playerItemDidReachEnd:", name: AVPlayerItemDidPlayToEndTimeNotification, object: currentItem)
//                notificationCenter.addObserver(this, selector: "playerItemNewErrorLogEntryNotification:", name: AVPlayerItemNewErrorLogEntryNotification, object: currentItem)
//                notificationCenter.addObserver(this, selector: "playerItemFailedtoPlayToEnd:", name: AVPlayerItemFailedToPlayToEndTimeNotification, object: currentItem)
//                notificationCenter.addObserver(this, selector: "playerItemPlaybackStalledNotification:", name: AVPlayerItemPlaybackStalledNotification, object: currentItem)
                player.actionAtItemEnd = AVPlayerActionAtItemEnd.None
            }
        }
    }
    
    
//    override func startAnimation() {
//        super.startAnimation()
//        
////        guard let birds = self.birds, bird = birds.first, camera = bird.cameras?.first else {
////            return
////        }
////        
////        let bounds = self.bounds
////        
////        camera.getStreamURL() { [weak self] streamURL, error in
////            guard let streamURL = streamURL else {
////                return
////            }
////        
////            let player = AVPlayer(URL: streamURL)
//////            let playerViewController = AVPlayerViewController()
//////            playerViewController.player = player
//////            
//////            // present player
//////            self?.presentViewController(playerViewController, animated: true) {
//////                playerViewController.player?.play()
//////            }
////            
////            let avPlayerLayer = AVPlayerLayer(player: player)
////            avPlayerLayer.frame = bounds
////        }
//    }
//    
//    override func stopAnimation() {
//        super.stopAnimation()
//    }
//    
//    override func drawRect(rect: NSRect) {
//        super.drawRect(rect)
//    }
//    
//    override func animateOneFrame() {
//        
//    }
//    
//    override func hasConfigureSheet() -> Bool {
//        return false
//    }
//    
//    override func configureSheet() -> NSWindow? {
//        return nil
//    }
}