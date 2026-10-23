//
//  DefaultsStorageTests.swift
//  PomodoroTests
//
//  Created by Lisa Fellows on 2026-10-20.
//

import XCTest
@testable import Pomodoro

final class DefaultsStorageTests: XCTestCase {
    func testDefaultsStorageSetsAndPersistsKeys() {
        let suiteName = "PomodoroTests_\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defer {
            defaults.removePersistentDomain(forName: suiteName)
        }

        var storage = DefaultsStorage(defaults: defaults)
        // Starting defaults
        XCTAssertEqual(storage.breakMinutes, SessionMetrics.defaultBreakMinutes)
        XCTAssertEqual(storage.completedSessions, 0)
        XCTAssertEqual(storage.sessionMode, SessionMode.defaultMode)
        XCTAssertEqual(storage.targetedSessionCount, 4)
        XCTAssertEqual(storage.timeRemaining, 0)
        XCTAssertEqual(storage.workMinutes, SessionMetrics.defaultWorkMinutes)

        storage.breakMinutes = 5
        storage.completedSessions = 4
        storage.sessionMode = .break
        storage.targetedSessionCount = 6
        storage.timeRemaining = 45
        storage.workMinutes = 60

        XCTAssertEqual(storage.breakMinutes, 5)
        XCTAssertEqual(storage.completedSessions, 4)
        XCTAssertEqual(storage.sessionMode, .break)
        XCTAssertEqual(storage.targetedSessionCount, 6)
        XCTAssertEqual(storage.timeRemaining, 45)
        XCTAssertEqual(storage.workMinutes, 60)

        // Should persist on new init
        let newStorage = DefaultsStorage(defaults: defaults)
        XCTAssertEqual(newStorage.breakMinutes, 5)
        XCTAssertEqual(newStorage.completedSessions, 4)
        XCTAssertEqual(newStorage.sessionMode, .break)
        XCTAssertEqual(storage.targetedSessionCount, 6)
        XCTAssertEqual(newStorage.timeRemaining, 45)
        XCTAssertEqual(newStorage.workMinutes, 60)
    }
}
