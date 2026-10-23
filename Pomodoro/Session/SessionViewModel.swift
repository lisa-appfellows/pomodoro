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
    private let hapticEngine: (any HapticEngineProtocol)
    private let alarmPlayer: (any AlarmPlaying)

    var settingsIsPresented = false

    private(set) var isPlaying = false
    private(set) var currentMode: SessionMode
    private(set) var breakMinutes: Int
    private(set) var workMinutes: Int
    private(set) var targetedSessionCount: Int
    private(set) var timer: (any CountdownTiming)?

    private(set) var completedSessions: Int {
        didSet { defaultsStorage.completedSessions = completedSessions }
    }

    var currentInterval: TimeInterval {
        let minutes = currentMode == .break ? breakMinutes : workMinutes
        return SessionMetrics.asInterval(minutes)
    }

    init(
        defaultsStorage: DefaultsStorage = .shared,
        hapticEngine: (any HapticEngineProtocol)? = nil,
        alarmPlayer: (any AlarmPlaying)? = nil,
        timer: (any CountdownTiming)? = nil
    ) {
        self.defaultsStorage = defaultsStorage
        self.hapticEngine = hapticEngine ?? HapticEngine.shared
        self.alarmPlayer = alarmPlayer ?? AlarmPlayer.shared
        self.currentMode = defaultsStorage.sessionMode
        self.breakMinutes = defaultsStorage.breakMinutes
        self.workMinutes = defaultsStorage.workMinutes
        self.targetedSessionCount = defaultsStorage.targetedSessionCount
        self.completedSessions = defaultsStorage.completedSessions
        self.timer = timer ?? CountdownTimer()
        attachTimer()
    }

    func didReset() {
        hapticEngine.play(.reset)
        setIsPlaying(false, playHaptic: false)
        resetTimerInterval()
    }

    func didCancel() {
        hapticEngine.play(.cancel)
        setIsPlaying(false, playHaptic: false)
        setSessionModeAndResetTimer(newMode: .work, playHaptic: false)
        completedSessions = 0
    }

    func setIsPlaying(_ isPlaying: Bool, playHaptic: Bool = true) {
        self.isPlaying = isPlaying
        if !isPlaying {
            if playHaptic { hapticEngine.play(.pause) }
            timer?.pause()
            saveTimeRemaining()
        } else {
            if playHaptic { hapticEngine.play(.play) }
            timer?.start()
        }
    }

    func setSessionModeAndResetTimer(newMode: SessionMode, playHaptic: Bool = true) {
        guard !isPlaying else { return }
        if playHaptic { hapticEngine.play(.selection) }
        currentMode = newMode
        defaultsStorage.sessionMode = newMode
        resetTimerInterval()
    }

    func setBreakMinutes(_ newMinutes: Int) {
        hapticEngine.play(newMinutes > breakMinutes ? .increase : .decrease)
        if currentMode == .break {
            if isPlaying { setIsPlaying(false, playHaptic: false) }
            breakMinutes = newMinutes
            defaultsStorage.breakMinutes = breakMinutes
            resetTimerInterval()
            return
        }

        breakMinutes = newMinutes
        defaultsStorage.breakMinutes = newMinutes
    }

    func setWorkMinutes(_ newMinutes: Int) {
        hapticEngine.play(newMinutes > workMinutes ? .increase : .decrease)
        if currentMode == .work {
            if isPlaying { setIsPlaying(false, playHaptic: false) }
            workMinutes = newMinutes
            defaultsStorage.workMinutes = newMinutes
            resetTimerInterval()
            return
        }

        workMinutes = newMinutes
        defaultsStorage.workMinutes = newMinutes
    }

    func setTargetedSessionCount(_ newCount: Int) {
        hapticEngine.play(newCount > targetedSessionCount ? .increase : .decrease)
        targetedSessionCount = newCount
        defaultsStorage.targetedSessionCount = targetedSessionCount
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

    private func switchModesAndStartNew() {
        if isPlaying { setIsPlaying(false, playHaptic: false) }
        if currentMode == .work {
            hapticEngine.play(.modeComplete)
            alarmPlayer.play(.modeComplete)
            setSessionModeAndResetTimer(newMode: .break, playHaptic: false)
            setIsPlaying(true, playHaptic: false)
            return
        }
        hapticEngine.play(.sessionComplete)
        alarmPlayer.play(.sessionComplete)
        completedSessions += 1
        setSessionModeAndResetTimer(newMode: .work, playHaptic: false)
        if completedSessions >= targetedSessionCount { return }
        setIsPlaying(true, playHaptic: false)
    }
}
