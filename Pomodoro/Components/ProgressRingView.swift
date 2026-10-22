//
//  ProgressRingView.swift
//  Pomodoro
//
//  Created by Lisa Fellows on 2026-10-18.
//

import SwiftUI

struct ProgressRingView: View {
    let mode: SessionMode
    let timeRemaining: TimeInterval
    let totalDuration: TimeInterval

    @ScaledMetric(relativeTo: .largeTitle)
    private var timeSize: CGFloat = 36

    private var modeIcon: String {
        Theme.sessionIcon(mode)
    }

    private var modeText: LocalizedStringResource {
        mode == .work ?
        LocalKey.workSession :
        LocalKey.breakSession
    }

    private var modeTint: Color {
        Theme.sessionTint(mode)
    }

    private var progress: Double {
        SessionTime.progress(
            remaining: timeRemaining,
            total: totalDuration
        )
    }

    var body: some View {
        ZStack {
            trackRing
            fillRing
            innerContent
        }
        .padding()
    }

    private var trackRing: some View {
        Circle()
            .fill(.clear)
            .stroke(.secondary.opacity(0.2), lineWidth: 8)
    }

    private var fillRing: some View {
        Circle()
            .trim(from: 0, to: progress)
            .fill(.clear)
            .stroke(
                modeTint,
                style: StrokeStyle(lineWidth: 8, lineCap: .round)
            )
            .rotationEffect(.degrees(-90))
            .animation(.spring(duration: 0.4, bounce: 0.1), value: progress)
    }

    private var innerContent: some View {
        VStack(spacing: 8) {
            Text(SessionTime.format(for: timeRemaining))
                .font(.system(.largeTitle, design: .monospaced))
            Image(systemName: modeIcon)
                .foregroundStyle(modeTint)
                .frame(width: 25, height: 25)
            Text(modeText)
                .font(.system(.subheadline, weight: .thin))
        }
    }
}

#Preview {
    ProgressRingView(mode: .work, timeRemaining: 90, totalDuration: 360)
}
