//
//  SettingsView.swift
//  Pomodoro
//
//  Created by Lisa Fellows on 2026-10-22.
//

import SwiftUI

@MainActor
struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var vm: SessionViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 48) {
                    SettingsModeSection(
                        selection: sessionModeBinding,
                        currentMode: vm.currentMode
                    )
                    SettingsIntervalSection(
                        workMinutes: workMinutesBinding,
                        breakMinutes: breakMinutesBinding
                    )
                    SettingsSessionTargetSection(
                        target: $vm.targetedSessionCount
                    )
                }
                .padding(16)
            }
            .scrollContentBackground(.hidden)
            .background(Theme.settingsGradient.ignoresSafeArea())
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: SystemKey.xmarkCircle)
                            .foregroundStyle(.themeBeige)
                    }
                }
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
    SettingsView(vm: .init(
        defaultsStorage: PreviewSupport.defaultsStorage
    ))
}
