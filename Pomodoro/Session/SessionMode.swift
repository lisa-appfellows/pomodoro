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
}
