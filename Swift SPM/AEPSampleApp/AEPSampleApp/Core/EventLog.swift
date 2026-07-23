//
//  EventLog.swift
//  AEPSampleApp
//
//  A real, in-app buffer of the app's own SDK calls (fed by Log.sdk). The Dev
//  Console renders this. It is NOT the Assurance stream — Assurance shows the
//  full SDK event hub remotely in its web UI; this is the local companion so
//  you can see activity without leaving the app.
//

import Foundation
import Observation

@Observable
final class EventLog {
    @MainActor static let shared = EventLog()

    struct Entry: Identifiable, Hashable {
        let id = UUID()
        let time = Date()
        let message: String
    }

    private(set) var entries: [Entry] = []

    func record(_ message: String) {
        entries.insert(Entry(message: message), at: 0)
        if entries.count > 200 { entries.removeLast() }   // cap the buffer
    }

    func clear() { entries.removeAll() }
}
