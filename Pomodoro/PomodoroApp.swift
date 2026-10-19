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
        setupPickerAppearance()
    }

    var body: some Scene {
        WindowGroup {
            ContentView(defaultsStorage: .shared)
        }
    }

    private func setupPickerAppearance() {
        UISegmentedControl.appearance().backgroundColor = UIColor.systemGroupedBackground
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor.orange
        
        UISegmentedControl.appearance().setTitleTextAttributes([
            .foregroundColor: UIColor.secondaryLabel,
            .font: UIFont.systemFont(ofSize: 14, weight: .regular)
        ], for: .normal)
        
        UISegmentedControl.appearance().setTitleTextAttributes([
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 14, weight: .bold)
        ], for: .selected)
    }
}
