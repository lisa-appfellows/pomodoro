//
//  IntervalSettingsRow.swift
//  Pomodoro
//
//  Created by Lisa Fellows on 2026-10-18.
//

import SwiftUI

struct IntervalSettingsRow: View {
    @Binding var minutes: Int
    let mode: SessionMode

    var title: LocalizedStringResource {
        mode == .work ?
        LocalKey.workInterval :
        LocalKey.breakInterval
    }

    var iconName: String {
        mode == .work ?
        SystemKey.booksVerticalFill :
        SystemKey.cupSaucerFill
    }

    var iconTint: Color {
        mode == .work ? .orange : .secondary
    }

    var body: some View {
        HStack {
            Image(systemName: iconName)
                .font(.title3)
                .foregroundStyle(iconTint)
            Text(title)
                .font(.subheadline.bold())
            Spacer()
            Text(LocalKey.specificMinutes(minutes))
            Stepper(
                "Time Interval Stepper",
                value: $minutes,
                in: 5...60,
                step: 5
            )
            .labelsHidden()
        }
    }
}

#Preview("Work") {
    IntervalSettingsRow(
        minutes: .constant(25),
        mode: .work
    )
}

#Preview("Break") {
    IntervalSettingsRow(
        minutes: .constant(5),
        mode: .break
    )
}
