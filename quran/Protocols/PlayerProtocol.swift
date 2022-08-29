//
//  PlayerProtocol.swift
//  quran
//
//  Created by developer on 5/13/22.
//

import Foundation
import SwiftAudio

protocol Player {
    var player: AudioPlayer? { get set }
    var toPlayItem: AudioItem? { get set }
    var playlist: [String] { get set }
    var index: Int { get set }
    
    func play()
    func pause()
    func handleAudioPlayerStateChange(state: AudioPlayerState)
}

extension Player {
    
    func play() {
        
        guard toPlayItem != nil else { return }
        player?.play()
    }
    
    func pause() {
        
        guard toPlayItem != nil else { return }
        player?.pause()
    }
}
