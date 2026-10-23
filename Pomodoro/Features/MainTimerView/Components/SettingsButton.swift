//
//  SettingsButton.swift
//  Pomodoro
//
//  Created by Lisa Fellows on 2026-10-22.
//

import SwiftUI

struct SettingsButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: SystemKey.gear)
                .foregroundStyle(.themeBeige)
                .font(.largeTitle)
                .frame(width: 44, height: 44)
        }
    }
}
