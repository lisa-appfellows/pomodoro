//
//  SessionModePicker.swift
//  Pomodoro
//
//  Created by Lisa Fellows on 2026-10-18.
//

import SwiftUI

struct SessionModePicker: View {
    @Binding var selection: SessionMode

    var body: some View {
        Picker(label(for: selection), selection: $selection) {
            ForEach(SessionMode.allCases, id: \.self) { mode in
                Text(label(for: mode)).tag(mode)
            }
        }
        .pickerStyle(.segmented)
    }

    private func label(for mode: SessionMode) -> String {
        let resource = mode == .work ?
        LocalKey.work :
        LocalKey.break
        return String(localized: resource)
    }
}

#Preview {
    SessionModePicker(selection: .constant(.break))
}
