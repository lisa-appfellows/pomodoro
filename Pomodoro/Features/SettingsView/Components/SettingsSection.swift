//
//  SettingsSection.swift
//  Pomodoro
//
//  Created by Lisa Fellows on 2026-10-22.
//

import SwiftUI

struct SettingsSection<Content: View>: View {
    let icon: String
    let title: LocalizedStringResource
    let subtitle: LocalizedStringResource
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            SettingsHeader(
                icon: icon,
                title: title,
                subtitle: subtitle
            )
            Divider()
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct SettingsHeader: View {
    let icon: String
    let title: LocalizedStringResource
    let subtitle: LocalizedStringResource

    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
                .frame(width: 30, height: 30)
            VStack(alignment: .leading) {
                Text(title)
                    .font(.body.bold())
                Text(subtitle)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .foregroundStyle(.themeBeige)
        .textCase(.none)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
