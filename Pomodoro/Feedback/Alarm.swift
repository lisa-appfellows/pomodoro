//
//  Alarm.swift
//  Pomodoro
//
//  Created by Lisa Fellows on 2026-10-22.
//

import Foundation

enum Alarm {
    case modeComplete
    case sessionComplete

    var resource: String {
        switch self {
        case .modeComplete: return "LightBell"
        case .sessionComplete: return "MediumBell"
        }
    }
}
