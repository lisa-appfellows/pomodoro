//
//  PomodoroTests.swift
//  PomodoroTests
//
//  Created by Lisa Fellows on 2026-10-18.
//

import XCTest
@testable import Pomodoro

final class PomodoroTests: XCTestCase {
    func testSessionTimeCreatesAppropriateIntervalFromMinutes() {
        let minutes = 5
        let interval = SessionMetrics.asInterval(minutes)
        XCTAssertEqual(interval, 300)
    }

    func testSessionTimeProgressReturnsCorrectProgress() {
        let progress = SessionMetrics.progress(
            remaining: 25,
            total: 100
        )
        XCTAssertEqual(progress, 0.75)
    }

    func testSessionTimeFormatReturnsProperlyFormattedString() {
        let seconds: TimeInterval = 124
        let formatted = SessionMetrics.format(for: seconds)
        XCTAssertEqual(formatted, "02:04")
    }

    func testLocalKeyLocalizesToAppropriateLanguage() {
        var sessionsEn = LocalKey.sessions
        sessionsEn.locale = Locale(identifier: "en")
        XCTAssertEqual(String(localized: sessionsEn), "sessions")

        var sessionsEs = LocalKey.sessions
        sessionsEs.locale = Locale(identifier: "es")
        XCTAssertEqual(String(localized: sessionsEs), "sesiones")
    }

    func testInterpolatedLocalKeyReturnsInterpolatedLocalization() {
        var enMinutes = LocalKey.specificMinutes(25)
        enMinutes.locale = Locale(identifier: "en")
        XCTAssertEqual(String(localized: enMinutes), "25 min")

        var esMinutes = LocalKey.specificMinutes(25)
        esMinutes.locale = Locale(identifier: "es")
        XCTAssertEqual(String(localized: esMinutes), "25 min")
    }
}
