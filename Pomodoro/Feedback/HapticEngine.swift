//
//  HapticEngine.swift
//  Pomodoro
//
//  Created by Lisa Fellows on 2026-10-22.
//

import UIKit

@MainActor
protocol HapticEngineProtocol {
    func play(_ pattern: HapticPattern)
}

@MainActor
struct HapticEngine: HapticEngineProtocol {
    static let shared = HapticEngine()
    private init() {}

    private let light = UIImpactFeedbackGenerator(style: .light)
    private let medium = UIImpactFeedbackGenerator(style: .medium)
    private let notification = UINotificationFeedbackGenerator()
    private let selection = UISelectionFeedbackGenerator()

    func play(_ pattern: HapticPattern) {
        switch pattern {
        case .cancel, .decrease, .pause, .reset:
            light.impactOccurred()

        case .increase, .modeComplete, .play:
            medium.impactOccurred()

        case .selection:
            selection.selectionChanged()
            
        case .sessionComplete:
            notification.notificationOccurred(.success)
        }
    }
}
