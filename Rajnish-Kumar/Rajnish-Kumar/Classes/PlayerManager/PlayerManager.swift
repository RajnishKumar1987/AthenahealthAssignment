//
//  PlayerManager.swift
//  Rajnish-Kumar
//
//  Created by Rajnish Kumar on 18/05/19.
//  Copyright © 2019 Rajnish Kumar. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class PlayerManager: NSObject {
    
    public static let shared = PlayerManager()
    public var avPlayer: AVPlayer!
    var avAsset: AVAsset!
    public var avPlayerItem: AVPlayerItem!
    var currentTimeObserver: Any?

    
    var plyaerItemMetaData: PlayerItemMetaData!
    
    open func initilizePlayerWith(item: PlayerItemMetaData)  {
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
        
        self.plyaerItemMetaData = item
        setUpPlayer()
    }
    
    func setUpPlayer() {
        
        reremovePlayerObserver()
        guard let url = URL(string: self.plyaerItemMetaData.playbackURL!) else { return }
        avAsset = AVAsset(url: url)
        avPlayerItem = AVPlayerItem(asset: avAsset)
        
        if (avPlayer != nil) {
            avPlayer.replaceCurrentItem(with: avPlayerItem)
            addPlayerObserver()
            
        } else {
            avPlayer = AVPlayer(playerItem: avPlayerItem)
            addPlayerObserver()
            
        }
    }
    
    func addPlayerObserver()  {
        avPlayerItem?.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
        
    }
    
    func reremovePlayerObserver() {
        avPlayerItem?.removeObserver(self, forKeyPath: "status")
    }
    
   
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "status" {
            observePlayerStatus()
        }
        
        
    }
    
    //MARK:- check playItem status
    fileprivate func observePlayerStatus() {
        
        let status:AVPlayerItem.Status = (avPlayer?.currentItem?.status)!
        switch status {
        case .readyToPlay:
            avPlayer.play()
        case .failed:
            print("failed")
        default:
            print("Unknown")
            
        }
    }
    
    

    
    
}

class PlayerItemMetaData {
    public var playbackURL: String?
    public var title: String?
    public var contentId: String?
    
    public init() {
        
    }
}

