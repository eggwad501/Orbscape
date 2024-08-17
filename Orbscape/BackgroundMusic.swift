//
//  BackgroundMusic.swift
//  Orbscape
//
//  Created by Nick Ensey on 8/15/24.
//

import Foundation
import AVFoundation

// background music object
class BackgroundMusic {
    static let shared = BackgroundMusic()
    var audioPlayer: AVAudioPlayer?

    // plays the background music
    func playMusic() {
        let song = Bundle.main.url(forResource: "backgroundMusic", withExtension: "mp3")!
        
        if let player = audioPlayer, player.isPlaying {
            return
        } else {
            do {
                if audioPlayer == nil {
                    audioPlayer = try AVAudioPlayer(contentsOf: song)
                }
                audioPlayer?.volume = localStore.retrieveItem(identifier: "Insets")[0].value(forKey: "musicVal") as! Float
                audioPlayer?.numberOfLoops = -1
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    // stop playing music
    func stopMusic() {
        audioPlayer?.stop()
    }
    
    // updates the music volume
    func updateVolume() {
        audioPlayer?.volume = musicVolume
    }
}
