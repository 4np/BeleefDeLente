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
import CleanroomLogger

@objc(BeleefDeLenteView) class BeleefDeLenteView: ScreenSaverView {
    static var birds: [Bird]?
    
    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        
        // fetch birds
        fetchBirds() { [weak self] birds in
            self?.playRandomly(birds)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Networking
    
    private func fetchBirds(withCompletion completed: (birds: [Bird]) -> () = { birds in }) {
        if let birds = BeleefDeLenteView.birds {
            return completed(birds: birds)
        }
        
        // fetch the birds and statically cache them
        APIManager.sharedInstance.getBirds() { birds, error in
            guard let birds = birds else {
                Log.error?.message("could not fetch birds...")
                return
            }
            
            Log.debug?.message("fetched \(birds.count) birds")
            
            BeleefDeLenteView.birds = birds
            
            completed(birds: birds)
        }
    }
    
    //MARK: Get a random bird and camera
    
    private func playRandomly(birds: [Bird]) {
        let bird = birds[Int(arc4random_uniform(UInt32(birds.count)))]

        guard let cameras = bird.cameras else {
            Log.error?.message("bird has no cameras...")
            return
        }
        
        let camera = cameras[Int(arc4random_uniform(UInt32(cameras.count)))]
        
        camera.getStreamURL() { [weak self] streamURL, error in
            guard let streamURL = streamURL else {
                Log.error?.message("could not fetch stream url \(error)")
                return
            }
            
            self?.play(url: streamURL)
        }
    }

    
    //MARK: Player
    
    private func play(birds: [Bird]) {
        guard let camera = birds.first?.cameras?.first else {
            Log.error?.message("could not fetch a camera")
            return
        }
        
        camera.getStreamURL() { [weak self] streamURL, error in
            guard let streamURL = streamURL else {
                Log.error?.message("could not fetch stream url \(error)")
                return
            }
            
            self?.play(url: streamURL)
        }
    }
    
    private func play(url url: NSURL) {
        // stop listening for notifications
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self)

        // set up player layer
        let layer = CALayer()
        layer.backgroundColor = NSColor.blackColor().CGColor
        layer.delegate = self
        layer.needsDisplayOnBoundsChange = true
        layer.frame = self.bounds
        self.layer = layer
        self.wantsLayer = true
        
        // set up player
        let player = AVPlayer(URL: url)
        let playerLayer = AVPlayerLayer(player: player)
        if #available(OSX 10.10, *) {
            playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        }
        playerLayer.autoresizingMask = [CAAutoresizingMask.LayerWidthSizable, CAAutoresizingMask.LayerHeightSizable]
        playerLayer.frame = layer.bounds
        
        // add player layer
        layer.addSublayer(playerLayer)
        if player.rate == 0 {
            Log.debug?.message("start playing")
            player.play()
        }
        
        guard let currentItem = player.currentItem else {
            Log.error?.message("No current item!")
            return
        }
        
        notificationCenter.addObserver(self, selector: "playerItemDidReachEnd:", name: AVPlayerItemDidPlayToEndTimeNotification, object: currentItem)
        notificationCenter.addObserver(self, selector: "playerItemNewErrorLogEntryNotification:", name: AVPlayerItemNewErrorLogEntryNotification, object: currentItem)
        notificationCenter.addObserver(self, selector: "playerItemFailedtoPlayToEnd:", name: AVPlayerItemFailedToPlayToEndTimeNotification, object: currentItem)
        notificationCenter.addObserver(self, selector: "playerItemPlaybackStalledNotification:", name: AVPlayerItemPlaybackStalledNotification, object: currentItem)
        player.actionAtItemEnd = AVPlayerActionAtItemEnd.None
    }
}