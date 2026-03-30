//
//  AudioManager.swift
//  prjTradingCard
//
//  Created by Mate Chachkhiani on 2025-11-24.
//

import Foundation
import AVFoundation

class AudioManager: ObservableObject {
    static let shared = AudioManager()
    
    private var audioPlayer: AVAudioPlayer?
    @Published var isMusicPlaying = false
    @Published var volume: Float = 0.5 {
        didSet {
            audioPlayer?.volume = volume
        }
    }
    @Published var currentSong: String = "Persona2"
    
    
    let availableSongs: [(name: String, displayName: String, fileType: String)] = [
        ("Persona2", "Persona Theme", "mp3"),
        ("Persona", "Persona battle", "mp3"),
        ("Lumiere", "Lumiere", "mp3"),
        ("Ghost", "Ghost", "mp3"),
        ("IrisOut", "Reze", "mp3"),
    ]
    
    private init() {
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up audio session: \(error.localizedDescription)")
        }
    }
    
    func playBackgroundMusic(fileName: String, fileType: String) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: fileType) else {
            print("Could not find audio file: \(fileName).\(fileType)")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1 // Loop
            audioPlayer?.volume = volume
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            isMusicPlaying = true
            currentSong = fileName
            print("Background music started playing: \(fileName)")
        } catch {
            print("Could not play audio file: \(error.localizedDescription)")
        }
    }
    
    // switch to a different song
    func switchSong(to fileName: String, fileType: String) {
        let wasPlaying = isMusicPlaying
        stopMusic()
        
        if wasPlaying {
            playBackgroundMusic(fileName: fileName, fileType: fileType)
        } else {
            currentSong = fileName
        }
    }
    
    func stopMusic() {
        audioPlayer?.stop()
        isMusicPlaying = false
        print("Background music stopped")
    }
    
    func pauseMusic() {
        audioPlayer?.pause()
        isMusicPlaying = false
    }
    
    func resumeMusic() {
        audioPlayer?.play()
        isMusicPlaying = true
    }
    
    func toggleMusic() {
        if isMusicPlaying {
            pauseMusic()
        } else {
            resumeMusic()
        }
    }
    
    func setVolume(_ volume: Float) {
        self.volume = max(0.0, min(1.0, volume)) 
    }
}
