//
//  TimerProgressView.swift
//  Pomodoro
//
//  Created by Lisa Fellows on 2026-10-22.
//

import SwiftUI

struct TimerProgressView: View {
    let currentMode: SessionMode
    let timeRemaining: TimeInterval?
    let totalDuration: TimeInterval

    private var remaining: TimeInterval {
        timeRemaining ?? 0
    }

    private var progress: Double {
        SessionMetrics.progress(
            remaining: remaining,
            total: totalDuration
        )
    }

    var body: some View {
        ZStack {
            Circle()
                .fill(.clear)
                .stroke(.themeBeige.opacity(0.3), lineWidth: 8)
            Circle()
                .trim(from: 0, to: progress)
                .fill(.clear)
                .stroke(.themeBeige, style: .init(lineWidth: 8, lineCap: .round))
                .rotationEffect(.degrees(-90))
            ProgressContent(currentMode: currentMode, timeRemaining: remaining)
        }
    }
}

private struct ProgressContent: View {
    let currentMode: SessionMode
    let timeRemaining: TimeInterval

    @ScaledMetric(relativeTo: .largeTitle)
    private var fontSize: CGFloat = 72

    private var formatted: String {
        SessionMetrics.format(for: timeRemaining)
    }

    private var modeText: LocalizedStringResource {
        currentMode == .work ? LocalKey.work : LocalKey.break
    }

    var body: some View {
        VStack(spacing: 0) {
            Text(formatted)
                .font(.system(size: fontSize, design: .serif))
                .monospacedDigit()
            HStack {
                Rectangle().stroke(lineWidth: 1).frame(height: 1)
                Image(systemName: SystemKey.suitDiamondFill).imageScale(.small)
                Rectangle().stroke(lineWidth: 1).frame(height: 1)
            }
            .frame(width: 100)
            Text(modeText)
                .font(.system(.title, design: .serif))
                .padding(.top, 8)
        }
        .foregroundStyle(.themeBeige)
    }
}
