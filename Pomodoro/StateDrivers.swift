//
//  StateDrivers.swift
//  Pomodoro
//
//  Created by Lisa Fellows on 2026-10-18.
//

import SwiftUI

enum TimeIntervalAdjuster {
    static let intervalRange = 5...60
    
}

struct StepperView: View {
    @State private var value = 5
    private var valueString: LocalizedStringResource {
        LocalKey.specificMinutes(value)
    }
    var body: some View {
        HStack {
            Spacer()
            Text(valueString)
            Stepper("Time Interval Stepper", value: $value, in: 5...60, step: 5)
                .labelsHidden()
                .frame(width: 150)
        }
    }
}

#Preview {
    StepperView()
}
