//
//  SessionViewModelTests.swift
//  PomodoroTests
//
//  Created by Lisa Fellows on 2026-10-21.
//

import XCTest
@testable import Pomodoro

@MainActor
final class SessionViewModelTests: XCTestCase {
    private var suiteName: String!
    private var defaults: UserDefaults!
    private var defaultsStorage: DefaultsStorage!
    private var timer: TestCountdownTimer!
    private var sut: SessionViewModel!

    private var newSut: SessionViewModel {
        .init(defaultsStorage: defaultsStorage, timer: timer)
    }

    private let defaultWorkMinutes = SessionMetrics.defaultWorkMinutes
    private let defaultWorkInterval = SessionMetrics
        .asInterval(SessionMetrics.defaultWorkMinutes)

    private let defaultBreakMinutes = SessionMetrics.defaultBreakMinutes
    private let defaultBreakInterval = SessionMetrics
        .asInterval(SessionMetrics.defaultBreakMinutes)

    override func setUp() {
        super.setUp()
        let suiteName = "ContentViewModelTests_defaultsSuite_\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        let storage = DefaultsStorage(defaults: defaults)
        let timer = TestCountdownTimer()
        
        self.suiteName = suiteName
        self.defaults = defaults
        self.defaultsStorage = storage
        self.timer = timer
        self.sut = .init(defaultsStorage: storage, timer: timer)
    }
    
    override func tearDown() {
        defaults.removePersistentDomain(forName: suiteName)
        suiteName = nil
        defaults = nil
        defaultsStorage = nil
        timer = nil
        sut = nil
        super.tearDown()
    }
    
    func testViewModelDefaultsAreSet() {
        XCTAssertEqual(sut.currentMode, .work)
        XCTAssertEqual(sut.breakMinutes, defaultBreakMinutes)
        XCTAssertEqual(sut.workMinutes, defaultWorkMinutes)
        XCTAssertEqual(sut.targetedSessionCount, 4)
        XCTAssertEqual(sut.completedSessions, 0)
        XCTAssertEqual(timer.timeRemaining, sut.currentInterval)
        XCTAssertEqual(sut.currentInterval, defaultWorkInterval)
    }
    
    func testIsPlayingStartsAndPausesTimer() {
        XCTAssertFalse(timer.isRunning)
        
        sut.isPlaying = true
        XCTAssertTrue(timer.isRunning)
        
        sut.isPlaying = false
        XCTAssertFalse(timer.isRunning)
    }

    func testSessionModeSetsAndResetsOnPause() {
        timer.set(for: 4)
        XCTAssertEqual(sut.currentMode, .work)
        XCTAssertEqual(sut.currentInterval, defaultWorkInterval)
        XCTAssertEqual(timer.timeRemaining, 4)

        sut.setSessionModeAndResetTimer(newMode: .break)
        XCTAssertEqual(sut.currentMode, .break)
        XCTAssertEqual(sut.currentInterval, defaultBreakInterval)
        XCTAssertEqual(timer.timeRemaining, sut.currentInterval)

        let newSut = newSut
        XCTAssertEqual(newSut.currentMode, .break)
    }

    func testSessionModeDoesNotSetOnPlay() {
        XCTAssertEqual(sut.currentMode, .work)

        sut.isPlaying = true
        sut.setSessionModeAndResetTimer(newMode: .break)
        XCTAssertEqual(sut.currentMode, .work)
        XCTAssertEqual(timer.timeRemaining, defaultWorkInterval)
    }

    func testWorkMinutesSetsOnPause() {
        XCTAssertEqual(sut.workMinutes, defaultWorkMinutes)
        XCTAssertEqual(sut.currentInterval, defaultWorkInterval)
        XCTAssertEqual(timer.timeRemaining, defaultWorkInterval)
        XCTAssertEqual(defaultsStorage.workMinutes, defaultWorkMinutes)

        let newMinutes = 35
        let newInterval = SessionMetrics.asInterval(newMinutes)

        sut.setWorkMinutes(newMinutes)

        XCTAssertEqual(sut.workMinutes, newMinutes)
        XCTAssertEqual(sut.currentInterval, newInterval)
        XCTAssertEqual(timer.timeRemaining, newInterval)
        XCTAssertEqual(defaultsStorage.workMinutes, newMinutes)

        let newSut = newSut
        XCTAssertEqual(newSut.workMinutes, newMinutes)
    }

    func testBreakMinutesSetsOnPause() {
        sut.setSessionModeAndResetTimer(newMode: .break)

        XCTAssertEqual(sut.breakMinutes, defaultBreakMinutes)
        XCTAssertEqual(sut.currentInterval, defaultBreakInterval)
        XCTAssertEqual(timer.timeRemaining, defaultBreakInterval)
        XCTAssertEqual(defaultsStorage.breakMinutes, defaultBreakMinutes)

        let newMinutes = 35
        let newInterval = SessionMetrics.asInterval(newMinutes)
    
        sut.setBreakMinutes(newMinutes)

        XCTAssertEqual(sut.breakMinutes, newMinutes)
        XCTAssertEqual(sut.currentInterval, newInterval)
        XCTAssertEqual(timer.timeRemaining, newInterval)
        XCTAssertEqual(defaultsStorage.breakMinutes, newMinutes)

        let newSut = newSut
        XCTAssertEqual(newSut.breakMinutes, newMinutes)
    }

    func testWorkMinutesSetOnWorkModeIsPlayingDoesPauseSetAndReset() {
        sut.isPlaying = true
        XCTAssertTrue(sut.isPlaying)

        let newMinutes = 35
        let newInterval = SessionMetrics.asInterval(newMinutes)

        sut.setWorkMinutes(newMinutes)

        XCTAssertFalse(sut.isPlaying)
        XCTAssertEqual(sut.workMinutes, newMinutes)
        XCTAssertEqual(sut.currentInterval, newInterval)
        XCTAssertEqual(timer.timeRemaining, newInterval)
        XCTAssertEqual(defaultsStorage.workMinutes, newMinutes)
    }

    func testBreakMinutesSetOnBreakModeIsPlayingDoesPauseSetAndReset() {
        sut.setSessionModeAndResetTimer(newMode: .break)
        sut.isPlaying = true
        XCTAssertTrue(sut.isPlaying)

        let newMinutes = 35
        let newInterval = SessionMetrics.asInterval(newMinutes)

        sut.setBreakMinutes(newMinutes)

        XCTAssertFalse(sut.isPlaying)
        XCTAssertEqual(sut.breakMinutes, newMinutes)
        XCTAssertEqual(sut.currentInterval, newInterval)
        XCTAssertEqual(timer.timeRemaining, newInterval)
        XCTAssertEqual(defaultsStorage.breakMinutes, newMinutes)
    }

    func testWorkMinutesSetOnBreakModeIsPlayingDoesUpdateWorkMinAndStorageOnly() {
        sut.setSessionModeAndResetTimer(newMode: .break)
        sut.isPlaying = true
        XCTAssertTrue(sut.isPlaying)

        let newMinutes = 15
        let newInterval = SessionMetrics.asInterval(newMinutes)

        sut.setWorkMinutes(newMinutes)

        XCTAssertTrue(sut.isPlaying)
        XCTAssertEqual(sut.workMinutes, newMinutes)
        XCTAssertNotEqual(sut.currentInterval, newInterval)
        XCTAssertNotEqual(timer.timeRemaining, newInterval)
        XCTAssertEqual(defaultsStorage.workMinutes, newMinutes)
    }

    func testBreakMinutesSetOnWorkModeIsPlayingDoesUpdateBreakMinAndStorageOnly() {
        sut.isPlaying = true
        XCTAssertTrue(sut.isPlaying)

        let newMinutes = 15
        let newInterval = SessionMetrics.asInterval(newMinutes)

        sut.setBreakMinutes(newMinutes)

        XCTAssertTrue(sut.isPlaying)
        XCTAssertEqual(sut.breakMinutes, newMinutes)
        XCTAssertNotEqual(sut.currentInterval, newInterval)
        XCTAssertNotEqual(timer.timeRemaining, newInterval)
        XCTAssertEqual(defaultsStorage.breakMinutes, newMinutes)
    }

    func testTargetedSessionCountSetsAndPersists() {
        XCTAssertEqual(sut.targetedSessionCount, 4) // default
        XCTAssertEqual(defaultsStorage.targetedSessionCount, 4)

        sut.targetedSessionCount = 6

        XCTAssertEqual(sut.targetedSessionCount, 6)
        XCTAssertEqual(defaultsStorage.targetedSessionCount, 6)

        let newSut = newSut
        XCTAssertEqual(newSut.targetedSessionCount, 6)
    }

    func testCompletedSessionsSetsAndPersists() {
        XCTAssertEqual(sut.completedSessions, 0)
        XCTAssertEqual(defaultsStorage.completedSessions, 0)

        // Advance completedSessions
        sut.setSessionModeAndResetTimer(newMode: .break)
        timer.callDidFinish()
        XCTAssertEqual(sut.completedSessions, 1)
        XCTAssertEqual(defaultsStorage.completedSessions, 1)

        let newSut = newSut
        XCTAssertEqual(newSut.completedSessions, 1)
    }

    func testSaveTimeRemainingSavesAndPersists() {
        XCTAssertEqual(defaultsStorage.timeRemaining, 0)
        XCTAssertEqual(timer.timeRemaining, sut.currentInterval) // defaulted value on 0 storage

        timer.set(for: 60)
        sut.saveTimeRemaining()
        XCTAssertEqual(defaultsStorage.timeRemaining, 60)

        let newSut = newSut
        XCTAssertEqual(newSut.timer?.timeRemaining, 60)
    }

    func testResetStopsPlayingAndResetsWithCurrentInterval() {
        sut.setSessionModeAndResetTimer(newMode: .break) // to show reset doesn't touch mode
        timer.set(for: 3) // altered time to show resets

        sut.isPlaying = true

        XCTAssertTrue(sut.isPlaying)
        XCTAssertTrue(timer.isRunning)
        XCTAssertEqual(timer.timeRemaining, 3)
        XCTAssertEqual(sut.currentMode, .break)

        sut.didReset()

        XCTAssertFalse(sut.isPlaying)
        XCTAssertFalse(timer.isRunning)
        XCTAssertEqual(timer.timeRemaining, sut.currentInterval)
        XCTAssertEqual(sut.currentMode, .break)
    }

    func testResetDoesNotResetCompletedSessions() {
        // Change completedSessions to 1 to show change back to 0
        sut.setSessionModeAndResetTimer(newMode: .break)
        timer.callDidFinish()
        XCTAssertEqual(sut.completedSessions, 1)

        sut.didReset()

        XCTAssertEqual(sut.completedSessions, 1)
    }

    func testCancelResetsToWorkDefaultResetsTimerWithWorkIntervalAndClearsCompletedSessions() {
        sut.setSessionModeAndResetTimer(newMode: .break) // to show cancel resets to .work
        timer.set(for: 3) // altered time to show resets

        sut.isPlaying = true

        XCTAssertTrue(sut.isPlaying)
        XCTAssertTrue(timer.isRunning)
        XCTAssertEqual(timer.timeRemaining, 3)
        XCTAssertEqual(sut.currentMode, .break)

        sut.didCancel()

        XCTAssertFalse(sut.isPlaying)
        XCTAssertFalse(timer.isRunning)
        XCTAssertEqual(sut.currentMode, .work)
        XCTAssertEqual(sut.currentInterval, TimeInterval(sut.workMinutes*60))
        XCTAssertEqual(timer.timeRemaining, sut.currentInterval)
    }

    func testCancelDoesResetCompletedSessionToZero() {
        // Change completedSessions to 1
        sut.setSessionModeAndResetTimer(newMode: .break)
        timer.callDidFinish()
        XCTAssertEqual(sut.completedSessions, 1)

        sut.didCancel()

        XCTAssertEqual(sut.completedSessions, 0)
    }

    func testSwitchModesOnWorkSwitchesToBreakResetsTimerAndStarts() {
        sut.setBreakMinutes(10)
        sut.setWorkMinutes(15)

        XCTAssertEqual(sut.currentMode, .work)
        XCTAssertEqual(sut.completedSessions, 0)
        XCTAssertFalse(sut.isPlaying)
        XCTAssertFalse(timer.isRunning)
        XCTAssertEqual(timer.timeRemaining, 15*60)

        sut.isPlaying = true
        XCTAssertTrue(sut.isPlaying)
        XCTAssertTrue(timer.isRunning)

        timer.callDidFinish()

        XCTAssertEqual(sut.currentMode, .break)
        XCTAssertEqual(sut.completedSessions, 0)
        XCTAssertTrue(sut.isPlaying)
        XCTAssertTrue(timer.isRunning)
        XCTAssertEqual(timer.timeRemaining, 10*60)
    }

    func testSwitchModesOnBreakSwitchesToWorkUpdatesCompletedResetsTimerAndStarts() {
        sut.setBreakMinutes(10)
        sut.setWorkMinutes(15)
        sut.setSessionModeAndResetTimer(newMode: .break)

        XCTAssertEqual(sut.currentMode, .break)
        XCTAssertEqual(sut.completedSessions, 0)
        XCTAssertFalse(sut.isPlaying)
        XCTAssertFalse(timer.isRunning)
        XCTAssertEqual(timer.timeRemaining, 10*60)

        sut.isPlaying = true
        XCTAssertTrue(sut.isPlaying)
        XCTAssertTrue(timer.isRunning)

        timer.callDidFinish()

        XCTAssertEqual(sut.currentMode, .work)
        XCTAssertEqual(sut.completedSessions, 1)
        XCTAssertTrue(sut.isPlaying)
        XCTAssertTrue(timer.isRunning)
        XCTAssertEqual(timer.timeRemaining, 15*60)
    }

    func testSwitchModesDoesNotSwitchOnTargetCountCompletion() {
        sut.targetedSessionCount = 1
        sut.isPlaying = true

        XCTAssertEqual(sut.completedSessions, 0)
        XCTAssertEqual(sut.currentMode, .work)
        XCTAssertTrue(sut.isPlaying)

        timer.callDidFinish()
        XCTAssertEqual(sut.completedSessions, 0)
        XCTAssertEqual(sut.currentMode, .break)
        XCTAssertTrue(sut.isPlaying)

        timer.callDidFinish()
        XCTAssertEqual(sut.completedSessions, 1)
        XCTAssertEqual(sut.currentMode, .work)
        XCTAssertFalse(sut.isPlaying, "Should not have started new session on target completion")
    }
}

// MARK: - TestCountdownTimer
private final class TestCountdownTimer: CountdownTiming {
    private(set) var isRunning = false
    private(set) var timeRemaining: TimeInterval = 0
    var didFinish: (() -> Void)?
    
    func start() {
        isRunning = true
    }

    func pause() {
        isRunning = false
    }

    func set(for timeRemaining: TimeInterval) {
        self.timeRemaining = timeRemaining
    }

    func reset(with timeRemaining: TimeInterval) {
        self.isRunning = false
        self.timeRemaining = timeRemaining
    }

    func callDidFinish() {
        isRunning = false
        timeRemaining = 0
        didFinish?()
    }
}
