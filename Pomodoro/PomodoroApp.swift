//
//  PomodoroApp.swift
//  Pomodoro
//
//  Created by Lisa Fellows on 2026-10-18.
//

import SwiftUI

@main
struct PomodoroApp: App {
    init() {
        Theme.setStepperAppearance()
        Theme.setSliderAppearance()
    }

    var body: some Scene {
        WindowGroup {
            MainTimerView(defaultsStorage: .shared)
                .preferredColorScheme(.dark)
        }
    }
}
