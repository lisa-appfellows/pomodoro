//
//  CountdownTimer.swift
//  Pomodoro
//
//  Created by Lisa Fellows on 2026-10-18.
//

import Foundation

@MainActor
protocol CountdownTiming {
    var isRunning: Bool { get }
    var timeRemaining: TimeInterval { get }
    var didFinish: (() -> Void)? { get set }
    func start()
    func pause()
    func set(for timeRemaining: TimeInterval)
    func reset(with timeRemaining: TimeInterval)
}

@MainActor
@Observable
final class CountdownTimer: CountdownTiming {
    private let clock: any TimerClock

    private(set) var isRunning = false
    private(set) var timeRemaining: TimeInterval = 0

    private var targetDate: Date?
    private var countdownTask: Task<Void, Never>?

    var didFinish: (() -> Void)?

    init(clock: (any TimerClock)? = nil) {
        self.clock = clock ?? AppTimerClock()
    }
    
    func set(for timeRemaining: TimeInterval) {
        self.timeRemaining = timeRemaining
    }

    func start() {
        guard !isRunning else { return }
        isRunning = true
        targetDate = clock.now.addingTimeInterval(timeRemaining)

        countdownTask = Task { [weak self] in
            while self?.isRunning == true {
                guard let self, let targetDate else { return }

                let delta = targetDate.timeIntervalSince(self.clock.now)

                if delta <= 0 {
                    self.finish()
                    return
                }

                self.timeRemaining = ceil(delta)

                do {
                    try await clock.sleep(for: 1)
                    guard self.isRunning else { return }
                } catch {
                    return
                }
            }
        }
    }
    
    func pause() {
        guard isRunning else { return }
        isRunning = false
        countdownTask?.cancel()
        if let targetDate {
            let timeSince = targetDate.timeIntervalSince(clock.now)
            timeRemaining = max(0, ceil(timeSince))
        }
    }
    
    func reset(with timeRemaining: TimeInterval) {
        if isRunning { isRunning = false }
        countdownTask?.cancel()
        self.timeRemaining = timeRemaining
    }

    private func finish() {
        if isRunning { isRunning = false }
        countdownTask?.cancel()
        timeRemaining = 0
        didFinish?()
    }
}
