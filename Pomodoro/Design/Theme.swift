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

    static let mainGradient = RadialGradient(
        colors: [.themeBrown, .themeBlack],
        center: .center,
        startRadius: 0,
        endRadius: 300
    )

    static let settingsGradient = RadialGradient(
        colors: [.themeBrown, .themeBlack],
        center: .topLeading,
        startRadius: 0,
        endRadius: 300
    )

    static func sessionIcon(_ mode: SessionMode) -> String {
        mode == .work ? SystemKey.booksVerticalFill : SystemKey.cupSaucerFill
    }

    static func setSliderAppearance() {
        UISegmentedControl.appearance()
            .selectedSegmentTintColor = UIColor.themeBeige
        UISegmentedControl.appearance()
            .setTitleTextAttributes([.foregroundColor: UIColor.themeBeige], for: .normal)
        UISegmentedControl.appearance()
            .setTitleTextAttributes([.foregroundColor: UIColor.themeBlack], for: .selected)

    }

    static func setStepperAppearance() {
        UIStepper.appearance()
            .setDecrementImage(UIImage(systemName: SystemKey.minus)?
                .withTintColor(.themeBeige, renderingMode: .alwaysOriginal), for: .normal)
        UIStepper.appearance()
            .setIncrementImage(UIImage(systemName: SystemKey.plus)?
                .withTintColor(.themeBeige, renderingMode: .alwaysOriginal), for: .normal)
    }
}
