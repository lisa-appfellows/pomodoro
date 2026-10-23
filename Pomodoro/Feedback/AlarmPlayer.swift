//
//  AlarmPlayer.swift
//  Pomodoro
//
//  Created by Lisa Fellows on 2026-10-22.
//

import AVFoundation
import Foundation

@MainActor
protocol AlarmPlaying {
    func play(_ alarm: Alarm)
}

@MainActor
final class AlarmPlayer: AlarmPlaying {
    static let shared = AlarmPlayer()
    private var player: AVAudioPlayer?

    private init() {
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        try? AVAudioSession.sharedInstance().setActive(true)
    }

    func play(_ alarm: Alarm) {
        guard let url = Bundle.main.url(
            forResource: alarm.resource,
            withExtension: "wav"
        ) else {
            return
        }
        player = try? AVAudioPlayer(contentsOf: url)
        player?.play()
    }
}
