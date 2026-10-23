//
//  AppTitleView.swift
//  Pomodoro
//
//  Created by Lisa Fellows on 2026-10-22.
//

import SwiftUI

struct AppTitleView: View {
    var body: some View {
        Text(LocalKey.appTitle)
            .foregroundStyle(.themeBeige)
            .font(.custom("Cochin", size: 36, relativeTo: .largeTitle))
            .tracking(1.8)
    }
}
