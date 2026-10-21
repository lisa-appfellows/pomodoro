//
//  SessionMode.swift
//  Pomodoro
//
//  Created by Lisa Fellows on 2026-10-18.
//

import Foundation

enum SessionMode: String, CaseIterable {
    case  work, `break`

    static let defaultMode = Self.work
    static let minutesRange = 1...99
    var defaultMinutes: Int {
        switch self {
        case .break: return 5
        case .work: return 25
        }
    }
}
