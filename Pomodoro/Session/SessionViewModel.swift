//
//  SessionViewModel.swift
//  Pomodoro
//
//  Created by Lisa Fellows on 2026-10-18.
//

import Foundation

@MainActor
@Observable
final class SessionViewModel {
    private var defaultsStorage: DefaultsStorage

    var settingsIsPresented = false

    var isPlaying = false {
        didSet { playStateChanged() }
    }

    private(set) var currentMode: SessionMode
    private(set) var breakMinutes: Int
    private(set) var workMinutes: Int

    var targetedSessionCount: Int {
        didSet { defaultsStorage.targetedSessionCount = targetedSessionCount }
    }

    private(set) var completedSessions: Int {
        didSet { defaultsStorage.completedSessions = completedSessions }
    }

    private(set) var timer: (any CountdownTiming)?

    var currentInterval: TimeInterval {
        let minutes = currentMode == .break ? breakMinutes : workMinutes
        return SessionMetrics.asInterval(minutes)
    }

    init(defaultsStorage: DefaultsStorage = .shared, timer: (any CountdownTiming)? = nil) {
        self.defaultsStorage = defaultsStorage
        self.currentMode = defaultsStorage.sessionMode
        self.breakMinutes = defaultsStorage.breakMinutes
        self.workMinutes = defaultsStorage.workMinutes
        self.targetedSessionCount = defaultsStorage.targetedSessionCount
        self.completedSessions = defaultsStorage.completedSessions
        self.timer = timer ?? CountdownTimer()
        attachTimer()
    }

    func didReset() {
        isPlaying = false
        resetTimerInterval()
    }

    func didCancel() {
        isPlaying = false
        setSessionModeAndResetTimer(newMode: .work)
        completedSessions = 0
    }

    func saveTimeRemaining() {
        defaultsStorage.timeRemaining = timer?.timeRemaining ?? currentInterval
    }

    private func attachTimer() {
        var timeRemaining = defaultsStorage.timeRemaining
        if timeRemaining == 0 { timeRemaining = currentInterval }
        timer?.set(for: timeRemaining)
        timer?.didFinish = { [weak self] in
            self?.switchModesAndStartNew()
        }
    }

    private func resetTimerInterval() {
        let newTimeRemaining = currentInterval
        timer?.reset(with: newTimeRemaining)
        defaultsStorage.timeRemaining = newTimeRemaining
    }

    private func playStateChanged() {
        if !isPlaying {
            timer?.pause()
            saveTimeRemaining()
        } else {
            timer?.start()
        }
    }

    private func switchModesAndStartNew() {
        if isPlaying { isPlaying = false }
        if currentMode == .work {
            setSessionModeAndResetTimer(newMode: .break)
            isPlaying = true
            return
        }
        completedSessions += 1
        setSessionModeAndResetTimer(newMode: .work)
        if completedSessions >= targetedSessionCount { return }
        isPlaying = true
    }

    func setSessionModeAndResetTimer(newMode: SessionMode) {
        guard !isPlaying else { return }
        currentMode = newMode
        defaultsStorage.sessionMode = newMode
        resetTimerInterval()
    }

    func setBreakMinutes(_ newMinutes: Int) {
        if currentMode == .break {
            if isPlaying { isPlaying = false }
            breakMinutes = newMinutes
            defaultsStorage.breakMinutes = breakMinutes
            resetTimerInterval()
            return
        }

        breakMinutes = newMinutes
        defaultsStorage.breakMinutes = newMinutes
    }

    func setWorkMinutes(_ newMinutes: Int) {
        if currentMode == .work {
            if isPlaying { isPlaying = false }
            workMinutes = newMinutes
            defaultsStorage.workMinutes = newMinutes
            resetTimerInterval()
            return
        }

        workMinutes = newMinutes
        defaultsStorage.workMinutes = newMinutes
    }
}
