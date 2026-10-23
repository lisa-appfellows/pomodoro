//
//  SettingsIntervalSection.swift
//  Pomodoro
//
//  Created by Lisa Fellows on 2026-10-22.
//

import SwiftUI

struct SettingsIntervalSection: View {
    @Binding var workMinutes: Int
    @Binding var breakMinutes: Int

    var body: some View {
        SettingsSection(
            icon: SystemKey.clock, 
            title: LocalKey.intervalSettings,
            subtitle: LocalKey.intervalSettingsSub
        ) {
            SettingsIntervalRow(minutes: $workMinutes, mode: .work)
            Divider()
            SettingsIntervalRow(minutes: $breakMinutes, mode: .break)
        }
    }
}

private struct SettingsIntervalRow: View {
    @Binding var minutes: Int
    let mode: SessionMode

    var title: LocalizedStringResource {
        mode == .work ?
        LocalKey.workInterval :
        LocalKey.breakInterval
    }

    var specificMinutes: String {
        String(localized: LocalKey.specificMinutes(minutes))
    }

    init(minutes: Binding<Int>, mode: SessionMode) {
        _minutes = minutes
        self.mode = mode
    }

    var body: some View {
        HStack {
            Image(systemName: Theme.sessionIcon(mode))
                .font(.body)
                .foregroundStyle(.themeBeige)
            Text(title)
                .font(.subheadline.bold())
            Spacer()
            Text(specificMinutes)
            Stepper(
                specificMinutes,
                value: $minutes,
                in: 5...60,
                step: 5
            )
            .labelsHidden()
            .tint(.themeBeige)
        }
        .foregroundStyle(.themeBeige)
    }
}
