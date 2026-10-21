//
//  PomodoroTests.swift
//  PomodoroTests
//
//  Created by Lisa Fellows on 2026-10-18.
//

import XCTest
@testable import Pomodoro

final class PomodoroTests: XCTestCase {
    func testSessionTimeProgressReturnsCorrectProgress() {
        let progress = SessionTime.progress(
            remaining: 25,
            total: 100
        )
        XCTAssertEqual(progress, 0.75)
    }

    func testSessionTimeFormatReturnsProperlyFormattedString() {
        let seconds: TimeInterval = 124
        let formatted = SessionTime.format(for: seconds)
        XCTAssertEqual(formatted, "02:04")
    }

    func testLocalKeyLocalizesToAppropriateLanguage() {
        var cancelEn = LocalKey.cancel
        cancelEn.locale = Locale(identifier: "en")
        XCTAssertEqual(String(localized: cancelEn), "Cancel")

        var cancelEs = LocalKey.cancel
        cancelEs.locale = Locale(identifier: "es")
        XCTAssertEqual(String(localized: cancelEs), "Cancelar")
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
