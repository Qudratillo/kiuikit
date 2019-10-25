//
//  KIAudioPlayer.swift
//  KIUIKit
//
//  Created by Kudratillo Ismatov on 10/25/19.
//  Copyright © 2019 Kudratillo Ismatov. All rights reserved.
//

import AVFoundation

class KIAudioPlayer {
    public typealias TimeCallback = (Double) -> Void
    
    
    private var player: AVPlayer
    
    private(set) var audioUrl: URL?
    private(set) var audioId: Int?
    private var timeDidChange: TimeCallback?
    private var completion: (()-> Void)?
    
    public var isPlaying: Bool {
        return player.timeControlStatus == .playing
    }
    
    public var currentTime: Double {
        return player.currentTime().seconds
    }
    
    public init() {
        player = .init()
        player.addPeriodicTimeObserver(forInterval: CMTimeMake(1, 10), queue: nil) { [weak self] (time) in
            self?.timeDidChange?(time.seconds)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    func playerDidFinishPlaying() {
        completion?()
    }
    
    public func play(audioUrl: URL, audioId: Int, timeDidChange: TimeCallback?, completion: (()->Void)?) {
        self.timeDidChange = timeDidChange
        self.completion = completion
        
        if self.audioId != audioId {
            self.audioUrl = audioUrl
            self.audioId = audioId
            play(url: audioUrl)
        } else {
            resume()
        }
    }
    
    public func subscribe(timeDidChange: TimeCallback?, completion: (()->Void)?) {
        self.timeDidChange = timeDidChange
        self.completion = completion
    }
    
    public func resume() {
        player.play()
    }
    
    public func pause() {
        player.pause()
    }
    
    public func seek(time: Double) {
        player.seek(to: .init(seconds: time, preferredTimescale: 1))
    }
    
    private func play(url: URL) {
        let asset: AVAsset = .init(url: url)
        player.replaceCurrentItem(with: .init(asset: asset, automaticallyLoadedAssetKeys: [AVURLAssetPreferPreciseDurationAndTimingKey]))
        player.play()
    }
}
