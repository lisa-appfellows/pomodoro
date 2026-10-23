//
//  PreviewSupport.swift
//  Pomodoro
//
//  Created by Lisa Fellows on 2026-10-22.
//

#if DEBUG
import Foundation

enum PreviewSupport {
    static var defaultsStorage: DefaultsStorage {
        .init(defaults: .init(suiteName: "preview_\(UUID().uuidString)")!)
    }
}
#endif
