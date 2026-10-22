//
//  TimerClock.swift
//  Pomodoro
//
//  Created by Lisa Fellows on 2026-10-21.
//

import Foundation

@MainActor
protocol TimerClock: Sendable {
    var now: Date { get }
    func sleep(for seconds: TimeInterval) async throws
}

@MainActor
struct AppTimerClock: TimerClock {
    var now: Date { Date() }
    func sleep(for seconds: TimeInterval) async throws {
        try await Task.sleep(for: .seconds(seconds))
    }
}
