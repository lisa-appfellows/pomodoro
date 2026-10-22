//
//  CountdownTimerTests.swift
//  PomodoroTests
//
//  Created by Lisa Fellows on 2026-10-21.
//

import XCTest
@testable import Pomodoro

@MainActor
final class CountdownTimerTests: XCTestCase {
    func testTimerFullCountdownWrapsUpAndCallsback() async {
        let clock = TestTimerClock()
        let timer = CountdownTimer(clock: clock)
        timer.set(for: 2)

        var didFinish = false
        timer.didFinish = { didFinish = true }

        timer.start()
        await clock.advance(by: 3)

        XCTAssertTrue(didFinish)
        XCTAssertFalse(timer.isRunning)
        XCTAssertEqual(timer.timeRemaining, 0)
    }

    func testPauseShouldNotResetAndShouldResumeOnStart() async {
        let clock = TestTimerClock()
        let timer = CountdownTimer(clock: clock)
        timer.set(for: 2)

        var didFinish = false
        timer.didFinish = { didFinish = true}

        timer.start()
        await clock.advance(by: 1)

        timer.pause()
        XCTAssertEqual(timer.timeRemaining, 1)

        timer.start()
        await clock.advance(by: 2)

        XCTAssertTrue(didFinish)
        XCTAssertFalse(timer.isRunning)
        XCTAssertEqual(timer.timeRemaining, 0)
    }

    func testResetShouldResetWithGivenTimeRemaining() async {
        let clock = TestTimerClock()
        let timer = CountdownTimer(clock: clock)
        timer.set(for: 2)

        timer.start()
        XCTAssertTrue(timer.isRunning)

        await clock.advance(by: 1)
        timer.reset(with: 5)

        XCTAssertFalse(timer.isRunning)
        XCTAssertEqual(timer.timeRemaining, 5)
    }
}

// MARK: - TestTimerClock
private final class TestTimerClock: TimerClock {
    private(set) var now: Date
    private var waiters: [CheckedContinuation<Void, Error>] = []

    init(starting: Date = Date(timeIntervalSince1970: 1_000_000)) {
        self.now = starting
    }
    
    func sleep(for seconds: TimeInterval) async throws {
        try await withCheckedThrowingContinuation { cont in
            waiters.append(cont)
        }
    }

    func advance(by seconds: TimeInterval) async {
        await waitUntil { !waiters.isEmpty }

        now.addTimeInterval(seconds)
        let pending = waiters
        waiters.removeAll()
        pending.forEach { $0.resume() }

        // Allow the timer task to run past the await
        await Task.yield()
    }

    private func waitUntil(timeout: TimeInterval = 3, _ condition: () -> Bool) async {
        let deadline = Date().addingTimeInterval(timeout)
        while Date() < deadline {
            if condition() { return }
            await Task.yield()
        }
        XCTFail("Condition never became true")
    }
}
