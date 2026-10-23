//
//  CompletedSessionTextView.swift
//  Pomodoro
//
//  Created by Lisa Fellows on 2026-10-22.
//

import SwiftUI

struct CompletedSessionTextView: View {
    let completed: Int
    let target: Int

    private var text: LocalizedStringResource {
        LocalKey.completedSessionsOverview(
            completed: completed,
            target: target
        )
    }

    var body: some View {
        Text(text)
            .font(.system(.body, design: .serif))
            .foregroundStyle(.themeBeige)
    }
}
