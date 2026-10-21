//
//  IntervalSettingsView.swift
//  Pomodoro
//
//  Created by Lisa Fellows on 2026-10-18.
//

import SwiftUI

struct IntervalSettingsView: View {
    @Binding var workMinutes: Int
    @Binding var breakMinutes: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            IntervalSettingsHeader()
            Divider()
            IntervalSettingsRow(minutes: $workMinutes, mode: .work)
            Divider()
            IntervalSettingsRow(minutes: $breakMinutes, mode: .break)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .cardBackground()
    }
}

private struct IntervalSettingsHeader: View {
    var body: some View {
        HStack {
            Image(systemName: SystemKey.clock)
                .font(.title2)
            VStack(alignment: .leading) {
                Text(LocalKey.intervalSettings)
                    .font(.body.bold())
                Text(LocalKey.intervalSettingsSub)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

private struct IntervalSettingsRow: View {
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

    var body: some View {
        HStack {
            Image(systemName: Theme.sessionIcon(mode))
                .font(.title3)
                .foregroundStyle(Theme.sessionTint(mode))
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
        }
    }
}

#Preview {
    IntervalSettingsView(workMinutes: .constant(25), breakMinutes: .constant(5))
}
