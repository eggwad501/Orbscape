//
//  BackgroundMusic.swift
//  Orbscape
//
//  Created by Nick Ensey on 8/15/24.
//

import Foundation
import AVFoundation

class BackgroundMusic {
    static let shared = BackgroundMusic()
    var audioPlayer: AVAudioPlayer?

    func playMusic() {
        let song = Bundle.main.url(forResource: "backgroundMusic", withExtension: "mp3")!
        
        if let player = audioPlayer, player.isPlaying {
            return
        } else {
            do {
                if audioPlayer == nil {
                    audioPlayer = try AVAudioPlayer(contentsOf: song)
                }
                // Add CORE DATA
                audioPlayer?.volume = musicVolume
                audioPlayer?.numberOfLoops = -1
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func stopMusic() {
        audioPlayer?.stop()
    }
    
    func updateVolume() {
        audioPlayer?.volume = musicVolume
    }
}
