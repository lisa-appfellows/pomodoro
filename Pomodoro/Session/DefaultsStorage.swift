//
//  DefaultsStorage.swift
//  Pomodoro
//
//  Created by Lisa Fellows on 2026-10-18.
//

import Foundation

struct DefaultsStorage {
    static let shared = Self.init(defaults: .standard)
    private let defaults: UserDefaults

    init(defaults: UserDefaults) {
        self.defaults = defaults
        defaults.register(defaults: [
            breakMinutesKey: SessionMetrics.defaultBreakMinutes,
            workMinutesKey: SessionMetrics.defaultWorkMinutes,
            targetedSessionCountKey: SessionMetrics.defaultTargetedSessionCount
        ])
    }

    private let breakMinutesKey = "breakMinutes"
    var breakMinutes: Int {
        get { defaults.integer(forKey: breakMinutesKey) }
        set { defaults.set(newValue, forKey: breakMinutesKey) }
    }

    private let completedSessionsKey = "completedSessions"
    var completedSessions: Int {
        get { defaults.integer(forKey: completedSessionsKey) }
        set { defaults.set(newValue, forKey: completedSessionsKey) }
    }

    private let sessionModeKey = "sessionMode"
    var sessionMode: SessionMode {
        get {
            let raw = defaults.string(forKey: sessionModeKey) ?? ""
            return .init(rawValue: raw) ?? .defaultMode
        }
        set {
            defaults.set(newValue.rawValue, forKey: sessionModeKey)
        }
    }

    private let targetedSessionCountKey = "targetedSessionCount"
    var targetedSessionCount: Int {
        get { defaults.integer(forKey: targetedSessionCountKey) }
        set { defaults.set(newValue, forKey: targetedSessionCountKey) }
    }

    private let timeRemainingKey = "timeRemaining"
    var timeRemaining: Double {
        get { defaults.double(forKey: timeRemainingKey) }
        set { defaults.set(newValue, forKey: timeRemainingKey) }
    }

    private let workMinutesKey = "workMinutes"
    var workMinutes: Int {
        get { defaults.integer(forKey: workMinutesKey) }
        set { defaults.set(newValue, forKey: workMinutesKey) }
    }
}
