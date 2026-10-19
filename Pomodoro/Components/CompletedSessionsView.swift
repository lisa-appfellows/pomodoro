//
//  CompletedSessionsView.swift
//  Pomodoro
//
//  Created by Lisa Fellows on 2026-10-18.
//

import SwiftUI

struct CompletedSessionsView: View {
    let completedSessions: Int
    @ScaledMetric(relativeTo: .largeTitle)
    private var countSize: CGFloat = 36
    private var subtext: LocalizedStringResource {
        completedSessions > 2 ?
        LocalKey.midCompletedSub :
        LocalKey.startingCompletedSub
    }
        
    var body: some View {
        HStack {
            Image(systemName: SystemKey.flameFill)
                .font(.title)
                .foregroundStyle(.tint)
            VStack(alignment: .leading) {
                Text(LocalKey.completedToday)
                    .font(.body.bold())
                Text(subtext)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text("\(completedSessions)")
                .font(.system(size: countSize, weight: .bold))
            Text(LocalKey.session)
                .font(.caption)
                .foregroundStyle(.primary.opacity(0.7))
                .padding(.top)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.secondarySystemBackground))
                .shadow(radius: 6)
        )
    }
}

#Preview {
    CompletedSessionsView(completedSessions: 4)
}
