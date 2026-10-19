//
//  SessionModePicker.swift
//  Pomodoro
//
//  Created by Lisa Fellows on 2026-10-18.
//

import SwiftUI

struct SessionModePicker: View {
    @Binding var selection: SessionMode

    var body: some View {
        Picker("Session Mode Picker", selection: $selection) {
            ForEach(SessionMode.allCases, id: \.self) { mode in
                Text(mode == .work ? LocalKey.work : LocalKey.break)
                    .tag(mode)
            }
        }
        .pickerStyle(.segmented)
    }
}

#Preview {
    SessionModePicker(selection: .constant(.break))
}

//struct SessionModePicker: View {
//    @Binding var currentMode: SessionMode
//
//    @Namespace private var animationNamespace
//    private let namespaceId = "selectedSpace"
//
//    var body: some View {
//        HStack(spacing: 0) {
//            segment(for: .work)
//            segment(for: .break)
//        }
//        .frame(height: 36)
//        .frame(maxWidth: .infinity)
//        .padding(4)
//        .background(
//            RoundedRectangle(cornerRadius: 16)
//                .fill(Color(.secondarySystemBackground))
//        )
//    }
//
//    private func segment(for mode: SessionMode) -> some View {
//        Button {
//            withAnimation {
//                currentMode = mode
//            }
//        } label: {
//            ZStack {
//                if currentMode == mode {
//                    RoundedRectangle(cornerRadius: 12)
//                        .fill(Color(.systemBackground))
//                        .matchedGeometryEffect(id: namespaceId, in: animationNamespace)
//                }
//                HStack {
//                    Circle()
//                        .fill(currentMode == mode ? .orange : .gray)
//                        .frame(width: 16, height: 16)
//                    Text(mode == .work ? LocalKey.work : LocalKey.break)
//                        .bold()
//                }
//            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//        }
//        .buttonStyle(.plain)
//    }
//}
//
//#if DEBUG
//struct SessionModePickerTestView: View {
//    @State private var mode = SessionMode.work
//
//    var body: some View {
//        SessionModePicker(currentMode: $mode)
//            .padding()
//    }
//}
//
//#Preview {
//    SessionModePickerTestView()
//}
//#endif
