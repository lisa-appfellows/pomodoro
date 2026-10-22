//
//  ContentView.swift
//  Pomodoro
//
//  Created by Lisa Fellows on 2026-10-18.
//

import SwiftUI

@MainActor
struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase

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
            SessionModePicker(selection: sessionModeBinding)
            IntervalSettingsView(
                workMinutes: workMinutesBinding,
                breakMinutes: breakMinutesBinding
            )
            CompletedSessionsView(completedSessions: vm.completedSessions)
        }
        .padding()
        .tint(Theme.tint)
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .background || newPhase == .inactive {
                vm.saveTimeRemaining()
            }
        }
    }

    private var sessionModeBinding: Binding<SessionMode> {
        Binding<SessionMode>(
            get: { self.vm.currentMode },
            set: { newValue in
                self.vm.setSessionModeAndResetTimer(newMode: newValue)
            }
        )
    }

    private var breakMinutesBinding: Binding<Int>{
        Binding<Int>(
            get: { self.vm.breakMinutes },
            set: { newValue in self.vm.setBreakMinutes(newValue) }
        )
    }

    private var workMinutesBinding: Binding<Int>{
        Binding<Int>(
            get: { self.vm.workMinutes },
            set: { newValue in self.vm.setWorkMinutes(newValue) }
        )
    }
}

#Preview {
    ContentView(defaultsStorage: .init(
        defaults: .init(suiteName: "preview_\(UUID().uuidString)")!
    ))
}
