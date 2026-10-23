//
//  LocalKey.swift
//  Pomodoro
//
//  Created by Lisa Fellows on 2026-10-18.
//

import Foundation

enum LocalKey {
    static let appTitle = makeKey("appTitle.key")
    static let `break` = makeKey("break.key")
    static let breakInterval = makeKey("breakInterval.key")
    static let intervalSettings = makeKey("intervalSettings.key")
    static let intervalSettingsSub = makeKey("intervalSettingsSub.key")
    static let minAbbreviated = makeKey("minAbbr.key")
    static let sessionMode = makeKey("sessionMode.key")
    static let sessionModeSub = makeKey("sessionModeSub.key")
    static let sessions = makeKey("sessions.key")
    static let sessionTargetCount = makeKey("sessionTargetCount.key")
    static let sessionTargetCountSub = makeKey("sessionTargetCountSub.key")
    static let work = makeKey("work.key")
    static let workInterval = makeKey("workInterval.key")

    static func makeKey(_ key: String.LocalizationValue) -> LocalizedStringResource {
        .init(key)
    }

    static func specificMinutes(_ minutes: Int) -> LocalizedStringResource {
        .init("specificMinutes.key", defaultValue: "\(minutes) min")
    }

    static func completedSessionsOverview(completed: Int, target: Int) -> LocalizedStringResource {
        .init("completedSessionsOverview.key", defaultValue: "\(completed) of \(target) sessions")
    }
}
