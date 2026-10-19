//
//  PlayControls.swift
//  Pomodoro
//
//  Created by Lisa Fellows on 2026-10-18.
//

import SwiftUI

enum SecondaryControl {
    case pause, reset
    var title: LocalizedStringResource {
        switch self {
        case .pause: return LocalKey.pause
        case .reset: return LocalKey.reset
        }
    }
    var icon: String {
        switch self {
        case .pause: return SystemKey.pauseFill
        case .reset: return SystemKey.arrowCounter
        }
    }
}

struct PlayControls: View {
    let didPause: () -> Void
    let didStart: () -> Void
    let didReset: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            secondaryControl(.pause)
            startControl()
            secondaryControl(.reset)
        }
    }

    private func startControl() -> some View {
        Button {
            didStart()
        } label: {
            HStack(spacing: 16) {
                Image(systemName: SystemKey.playFill)
                Text(LocalKey.start)
            }
            .foregroundStyle(.white)
            .font(.system(.title2, weight: .bold))
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(.tint)
                    .shadow(radius: 3)
            )
        }
    }

    private func secondaryControl(_ control: SecondaryControl) -> some View {
        Button {
            control == .pause ? didPause() : didReset()
        } label: {
            VStack(spacing: 8) {
                Image(systemName: control.icon)
                    .font(.title3)
                Text(control.title)
                    .font(.subheadline)
            }
            .bold()
            .foregroundStyle(Color(.label))
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.secondarySystemBackground))
                    .shadow(radius: 3)
            )
        }
    }
}

#Preview {
    PlayControls(didPause: {}, didStart: {}, didReset: {})
}
