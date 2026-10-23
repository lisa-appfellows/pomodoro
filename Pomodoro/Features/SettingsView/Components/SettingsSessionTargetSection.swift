//
//  SettingsSessionTargetSection.swift
//  Pomodoro
//
//  Created by Lisa Fellows on 2026-10-22.
//

import SwiftUI

struct SettingsSessionTargetSection: View {
    @Binding var target: Int

    var body: some View {
        SettingsSection(
            icon: SystemKey.clock,
            title: LocalKey.sessionTargetCount,
            subtitle: LocalKey.sessionTargetCountSub
        ) {
            HStack {
                Text(verbatim: "\(target)")
                    .font(.title2.bold())
                    .foregroundStyle(.themeBeige)
                Text(LocalKey.sessions)
                    .font(.subheadline.bold())
                    .foregroundStyle(.themeBeige)
                Spacer()
                Stepper(
                    String(localized: LocalKey.sessionTargetCount),
                    value: $target,
                    in: SessionMetrics.targetedSessionRange,
                    step: 1
                )
                .labelsHidden()
            }
        }
    }
}

#Preview {
    SettingsSessionTargetSection(target: .constant(4))
}
