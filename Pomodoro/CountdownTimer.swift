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
    private(set) var isRunning = false
    var timeRemaining: TimeInterval = 0

    private var targetDate: Date?
    private var countdownTask: Task<Void, Never>?
    
    var didFinish: (() -> Void)?
    
    func set(for timeRemaining: TimeInterval) {
        self.timeRemaining = timeRemaining
    }

    func start() {
        guard !isRunning else { return }
        isRunning = true

        targetDate = Date().addingTimeInterval(timeRemaining)
        countdownTask = Task { [weak self] in
            while self?.isRunning == true {
                guard let self, let targetDate else { return }

                let delta = targetDate.timeIntervalSince(Date())

                if delta <= 0 {
                    self.didFinish?()
                    return
                }

                self.timeRemaining = ceil(delta)

                do {
                    try await Task.sleep(for: .seconds(1.0))
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
            let timeSince = targetDate.timeIntervalSince(Date())
            timeRemaining = max(0, ceil(timeSince))
        }
    }
    
    func reset(with timeRemaining: TimeInterval) {
        if isRunning { isRunning = false }
        countdownTask?.cancel()
        self.timeRemaining = timeRemaining
    }
}
