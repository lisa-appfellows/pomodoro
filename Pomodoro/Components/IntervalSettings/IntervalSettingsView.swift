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
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.secondarySystemBackground))
                .shadow(radius: 6)
        )
    }
}

#Preview {
    IntervalSettingsView(workMinutes: .constant(25), breakMinutes: .constant(5))
}
