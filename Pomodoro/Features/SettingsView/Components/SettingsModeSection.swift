//
//  SettingsModeSection.swift
//  Pomodoro
//
//  Created by Lisa Fellows on 2026-10-22.
//

import SwiftUI

struct SettingsModeSection: View {
    @Binding var selection: SessionMode
    let currentMode: SessionMode
    
    var body: some View {
        SettingsSection(
            icon: Theme.sessionIcon(currentMode),
            title: LocalKey.sessionMode,
            subtitle: LocalKey.sessionModeSub
        ) {
            SessionModePicker(selection: $selection)
        }
    }
}

private struct SessionModePicker: View {
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
