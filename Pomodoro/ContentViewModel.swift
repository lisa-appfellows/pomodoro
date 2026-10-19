//
//  ContentViewModel.swift
//  Pomodoro
//
//  Created by Lisa Fellows on 2026-10-18.
//

import Foundation

@MainActor
@Observable
final class ContentViewModel {
    private var defaultsStorage: DefaultsStorage

    var currentMode: SessionMode = .work {
        didSet { defaultsStorage.sessionMode = currentMode }
    }

    var breakMinutes: Int {
        didSet { defaultsStorage.breakMinutes = breakMinutes }
    }

    var workMinutes: Int {
        didSet { defaultsStorage.workMinutes = workMinutes }
    }

    var completedSessions: Int {
        didSet { defaultsStorage.completedSessions = completedSessions }
    }

    private(set) var timer: (any CountdownTiming)?

    var currentInterval: TimeInterval {
        let minutes = currentMode == .break ? breakMinutes : workMinutes
        return TimeInterval(minutes * 60)
    }

    init(defaultsStorage: DefaultsStorage = .shared, timer: (any CountdownTiming)? = nil) {
        self.defaultsStorage = defaultsStorage
        self.currentMode = defaultsStorage.sessionMode
        self.breakMinutes = defaultsStorage.breakMinutes
        self.workMinutes = defaultsStorage.workMinutes
        self.completedSessions = defaultsStorage.completedSessions
        self.timer = timer ?? CountdownTimer()
        attachTimer()
    }

    func didStart() {
        timer?.start()
    }

    func didPause() {
        timer?.pause()
    }

    func didStop() {
        timer?.reset(with: currentInterval)
    }

    func didReset() {
        timer?.pause()
        currentMode = .work
        timer?.reset(with: currentInterval)
        completedSessions = 0
    }

    func saveTimeRemaining() {
        defaultsStorage.timeRemaining = timer?.timeRemaining ?? currentInterval
    }

    private func attachTimer() {
        let timeRemaining = defaultsStorage.timeRemaining
        timer?.set(for: timeRemaining)
        timer?.didFinish = { [weak self] in
            self?.switchModesAndStartNew()
        }
    }

    private func switchModesAndStartNew() {
        guard let timer, !timer.isRunning else { return }
        if currentMode == .break {
            completedSessions += 1
            currentMode = .work
        } else {
            currentMode = .break
        }
        timer.reset(with: currentInterval)
        timer.start()
    }
}
