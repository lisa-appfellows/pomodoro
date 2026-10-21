//
//  Theme.swift
//  Pomodoro
//
//  Created by Lisa Fellows on 2026-10-20.
//

import SwiftUI

enum Theme {
    static let background = Color(.systemBackground)
    static let secondaryBackground = Color(.secondarySystemBackground)
    static let cardBackground = Color(.tertiarySystemBackground)

    static let cornerRadius: CGFloat = 8
    static let shadowRadius: CGFloat = 6

    static let tint = Color.orange

    static func sessionIcon(_ mode: SessionMode) -> String {
        mode == .work ? SystemKey.booksVerticalFill : SystemKey.cupSaucerFill
    }

    static func sessionTint(_ mode: SessionMode) -> Color {
        mode == .work ? .orange : .gray
    }
}

// MARK: - Modifiers
extension View {
    func cardBackground() -> some View {
        modifier(CardBackgroundModifier())
    }
}

private struct CardBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: Theme.cornerRadius)
                    .fill(Theme.cardBackground)
                    .shadow(radius: Theme.shadowRadius)
            )
    }
}
