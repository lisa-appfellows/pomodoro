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

    private var modeText: LocalizedStringResource {
        mode == .work ?
        LocalKey.workSession :
        LocalKey.breakSession
    }

    private var progress: Double {
        guard totalDuration > 0 else { return 0.0 }
        let elapsed = totalDuration - timeRemaining
        return min(max(elapsed / totalDuration, 0.0), 1.0)
    }

    var body: some View {
        ZStack {
            Circle()
                .fill(.clear)
                .stroke(.secondary.opacity(0.2), lineWidth: 12)
            Circle()
                .trim(from: 0, to: progress)
                .fill(.clear)
                .stroke(.tint, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.spring(duration: 0.4, bounce: 0.1), value: progress)
            VStack {
                Text(formatTimeInterval(timeRemaining))
                    .font(.largeTitle.bold())
                Text(modeText)
                    .font(.system(.subheadline, weight: .thin))
                    .animation(.easeInOut(duration: 0.4), value: mode)
            }
        }
        .padding()
    }

    private func formatTimeInterval(_ interval: TimeInterval) -> String {
        let totalSeconds = Int(interval)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    ProgressRingView(mode: .work, timeRemaining: 90, totalDuration: 360)
}
