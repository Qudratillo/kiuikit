//
//  KIAudioPlayer.swift
//  KIUIKit
//
//  Created by Kudratillo Ismatov on 10/25/19.
//  Copyright © 2019 Kudratillo Ismatov. All rights reserved.
//

import AVFoundation

public class KIAudioPlayer {
    
    public static let shared = KIAudioPlayer()
    
    public typealias TimeCallback = (Double) -> Void
    
    
    private var player: AVPlayer
    
    public private(set) var audioUrl: URL?
    public private(set) var audioId: Int?
    private var timeDidChange: TimeCallback?
    private var completion: (()-> Void)?
    
    public private(set) var isPlaying: Bool = false
    
    public var currentTime: Double {
        let seconds = player.currentTime().seconds
        return (seconds.isInfinite || seconds.isNaN) ? 0 : seconds
    }
    
    public init() {
        player = .init()
        player.addPeriodicTimeObserver(forInterval: CMTimeMake(1, 100), queue: nil) { [weak self] (time) in
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
        isPlaying = false
        player.seek(to: CMTimeMake(0, 1))
    }
    
    public func play(audioUrl: URL, audioId: Int, timeDidChange: TimeCallback?, completion: (()->Void)?) {
        if self.audioId != audioId {
            self.completion?()
            self.audioUrl = audioUrl
            self.audioId = audioId
            play(url: audioUrl)
        } else {
            resume()
        }
        
        self.timeDidChange = timeDidChange
        self.completion = completion
        timeDidChange?(currentTime)
    }
    
    public func subscribe(timeDidChange: TimeCallback?, completion: (()->Void)?) {
        timeDidChange?(currentTime)
        self.timeDidChange = timeDidChange
        self.completion = completion
    }
    
    public func resume() {
        player.play()
        isPlaying = true
    }
    
    public func pause() {
        player.pause()
        isPlaying = false
    }
    
    public func seek(time: Double) {
        player.seek(to: .init(seconds: time, preferredTimescale: 1))
    }
    
    private func play(url: URL) {
        isPlaying = true
        let asset: AVAsset = AVURLAsset(url: url, options: [AVURLAssetPreferPreciseDurationAndTimingKey : true])
        
        player.replaceCurrentItem(with: .init(asset: asset))
        player.play()
    }
}
