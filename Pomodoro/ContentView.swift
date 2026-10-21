//
//  ContentView.swift
//  Pomodoro
//
//  Created by Lisa Fellows on 2026-10-18.
//

import SwiftUI

@MainActor
struct ContentView: View {
    @State private var vm: ContentViewModel
    init(defaultsStorage: DefaultsStorage) {
        let vm = ContentViewModel(defaultsStorage: defaultsStorage)
        _vm = State(initialValue: vm)
    }

    var body: some View {
        VStack(spacing: 16) {
            VStack {
                Text(LocalKey.appTitle)
                    .font(.title.bold())
                Text(LocalKey.appSubtitle)
                    .foregroundStyle(.secondary)
            }
            Divider()
            ProgressRingView(
                mode: vm.currentMode,
                timeRemaining: vm.timer?.timeRemaining ?? 0,
                totalDuration: vm.currentInterval
            )
            PlayControls(
                isPlaying: $vm.isPlaying,
                onCancel: { vm.didCancel() },
                onReset: { vm.didReset() }
            )
            SessionModePicker(selection: $vm.currentMode)
            IntervalSettingsView(
                workMinutes: $vm.workMinutes,
                breakMinutes: $vm.breakMinutes
            )
            CompletedSessionsView(completedSessions: vm.completedSessions)
        }
        .padding()
        .tint(Theme.tint)
    }
}

#Preview {
    ContentView(defaultsStorage: .init(
        defaults: .init(suiteName: "preview_\(UUID().uuidString)")!
    ))
}
