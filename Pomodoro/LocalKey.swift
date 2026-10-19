//
//  LocalKey.swift
//  Pomodoro
//
//  Created by Lisa Fellows on 2026-10-18.
//

import Foundation

enum LocalKey {
    static let appTitle = makeKey("appTitle.key")
    static let appSubtitle = makeKey("appSubtitle.key")
    static let `break` = makeKey("break.key")
    static let breakInterval = makeKey("breakInterval.key")
    static let breakSession = makeKey("breakSession.key")
    static let completedToday = makeKey("completedToday.key")
    static let intervalSettings = makeKey("intervalSettings.key")
    static let intervalSettingsSub = makeKey("intervalSettingsSub.key")
    static let midCompletedSub = makeKey("midCompletedSub.key")
    static let minAbbreviated = makeKey("minAbbr.key")
    static let pause = makeKey("pause.key")
    static let reset = makeKey("reset.key")
    static let start = makeKey("start.key")
    static let startingCompletedSub = makeKey("startingCompletedSub.key")
    static let session = makeKey("sessions.key")
    static let stop = makeKey("stop.key")
    static let work = makeKey("work.key")
    static let workInterval = makeKey("workInterval.key")
    static let workSession = makeKey("workSession.key")

    static func makeKey(_ key: String.LocalizationValue) -> LocalizedStringResource {
        .init(key)
    }

    static func specificMinutes(_ minutes: Int) -> LocalizedStringResource {
        .init("specificMinutes.key", defaultValue: "\(minutes) min")
    }
}
