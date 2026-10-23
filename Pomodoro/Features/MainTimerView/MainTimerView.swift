//
//  MainTimerView.swift
//  Pomodoro
//
//  Created by Lisa Fellows on 2026-10-22.
//

import SwiftUI

@MainActor
struct MainTimerView: View {
    @Environment(\.scenePhase) private var scenePhase
    @State private var vm: SessionViewModel

    init(defaultsStorage: DefaultsStorage) {
        let vm = SessionViewModel(defaultsStorage: defaultsStorage)
        _vm = State(initialValue: vm)
    }

    var body: some View {
        VStack {
            AppTitleView()
            Spacer()
            TimerProgressView(
                currentMode: vm.currentMode,
                timeRemaining: vm.timer?.timeRemaining,
                totalDuration: vm.currentInterval
            )
            Spacer()
            ControlView(
                isPlaying: $vm.isPlaying,
                onReset: { vm.didReset() },
                onCancel: { vm.didCancel() }
            )
            CompletedSessionTextView(
                completed: vm.completedSessions,
                target: vm.targetedSessionCount
            )
            .padding(.bottom)
            SettingsButton {
                vm.settingsIsPresented = true
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.mainGradient.ignoresSafeArea())
        .sheet(isPresented: $vm.settingsIsPresented) {
            SettingsView(vm: vm)
                .presentationDetents([.medium, .large])
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .background || newPhase == .inactive {
                vm.saveTimeRemaining()
            }
        }
    }
}

#Preview {
    MainTimerView(defaultsStorage: PreviewSupport.defaultsStorage)
}
