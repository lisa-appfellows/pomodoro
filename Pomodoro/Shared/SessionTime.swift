//
//  SessionTime.swift
//  Pomodoro
//
//  Created by Lisa Fellows on 2026-10-20.
//

import Foundation

enum SessionTime {
    static let defaultBreakMinutes: Int = 5
    static let defaultWorkMinutes: Int = 25

    static func progress(remaining: TimeInterval, total: TimeInterval) -> Double {
        guard total > 0 else { return 0.0 }
        let elapsed = total - remaining
        return min(max(elapsed / total, 0), 1.0)
    }

    static func format(for seconds: TimeInterval) -> String {
        let totalSeconds = Int(seconds)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
