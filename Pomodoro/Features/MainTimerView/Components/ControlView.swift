//
//  ControlView.swift
//  Pomodoro
//
//  Created by Lisa Fellows on 2026-10-22.
//

import SwiftUI

struct ControlView: View {
    @Binding var isPlaying: Bool
    let onReset: () -> Void
    let onCancel: () -> Void

    var body: some View {
        HStack {
            SecondaryControlButton(
                icon: SystemKey.arrowCounter,
                action: { onReset() }
            )
            .frame(maxWidth: .infinity)
            PrimaryControlButton(isPlaying: $isPlaying)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 24)
            SecondaryControlButton(
                icon: SystemKey.stopFill,
                action: { onCancel() }
            )
            .frame(maxWidth: .infinity)
        }
    }
}

private struct PrimaryControlButton: View {
    @Binding var isPlaying: Bool

    private var icon: String {
        isPlaying ?
        SystemKey.pauseFill :
        SystemKey.playFill
    }

    var body: some View {
        Button {
            isPlaying.toggle()
        } label: {
            Image(systemName: icon)
                .bold()
                .foregroundStyle(.themeBeige)
                .font(.largeTitle)
                .frame(width: 90, height: 90)
                .background(
                    Circle()
                        .fill(.themeBrown)
                )
        }
    }
}

private struct SecondaryControlButton: View {
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .foregroundStyle(.themeBeige)
                .font(.title)
                .frame(width: 60, height: 60)
                .background(
                    Circle()
                        .fill(.clear)
                        .strokeBorder(.themeBeige, lineWidth: 2)
                )
        }
    }
}
