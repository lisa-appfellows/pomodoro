//
//  PlayControls.swift
//  Pomodoro
//
//  Created by Lisa Fellows on 2026-10-18.
//

import SwiftUI

struct PlayControls: View {
    @Binding var isPlaying: Bool
    let onCancel: () -> Void
    let onReset: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            SecondaryControl(
                title: LocalKey.cancel,
                action: onCancel
            )
            PrimaryControl(isPlaying: $isPlaying)
            SecondaryControl(
                title: LocalKey.reset,
                icon: SystemKey.arrowCounter,
                action: onReset
            )
        }
    }
}

private struct PrimaryControl: View {
    @Binding var isPlaying: Bool

    private var icon: String {
        isPlaying ? 
        SystemKey.pauseFill :
        SystemKey.playFill
    }
    private var title: LocalizedStringResource {
        isPlaying ?
        LocalKey.pause :
        LocalKey.start
    }
    private var foregroundColor: Color {
        isPlaying ? Theme.tint : Theme.background
    }
    private var fillColor: Color {
        isPlaying ? .clear : Theme.tint
    }

    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.12)) {
                isPlaying.toggle()
            }
        } label: {
            HStack {
                Image(systemName: icon)
                Text(title)
            }
            .bold()
            .font(.title3)
            .foregroundStyle(foregroundColor)
            .frame(height: 60)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: Theme.cornerRadius)
                    .fill(fillColor)
                    .strokeBorder(Theme.tint)
            )
            .id(isPlaying)
            .transition(.opacity)
        }
        .animation(.easeInOut(duration: 0.12), value: isPlaying)
    }
}

private struct SecondaryControl: View {
    let title: LocalizedStringResource
    let icon: String?
    let action: () -> Void

    init(
        title: LocalizedStringResource,
        icon: String? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                if let icon { Image(systemName: icon) }
                Text(title)
            }
            .font(.subheadline)
            .foregroundStyle(Color(.label))
            .frame(width: 80, height: 80)
            .background(
                Circle().fill(Theme.secondaryBackground)
            )
        }
    }
}
