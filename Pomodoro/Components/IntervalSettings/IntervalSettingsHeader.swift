//
//  IntervalSettingsHeader.swift
//  Pomodoro
//
//  Created by Lisa Fellows on 2026-10-18.
//

import SwiftUI

struct IntervalSettingsHeader: View {
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

#Preview {
    IntervalSettingsHeader()
}
