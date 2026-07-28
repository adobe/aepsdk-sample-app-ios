//
//  EventLog.swift
//  AEPSampleApp
//
//  In-app buffer of REAL AEP SDK events, captured via a wildcard event-hub
//  listener (see AEPIntegration/Diagnostics/SDKEventRecorder). Data source for
//  the dedicated SDK Event Log screen — an in-app companion to Assurance. Stays
//  SDK-free; the recorder maps SDK events into Entry.
//

import Foundation
import Observation

@Observable
final class EventLog {
    @MainActor static let shared = EventLog()

    struct Entry: Identifiable, Hashable {
        let id = UUID()
        let time = Date()
        let name: String
        let type: String     // full XDM event type, e.g. com.adobe.eventType.edge
        let source: String   // full XDM event source
        let payload: String  // pretty-printed event data

        /// Short, readable forms for the list (drop the long com.adobe prefixes).
        var shortType: String { type.replacingOccurrences(of: "com.adobe.eventType.", with: "") }
        var shortSource: String { source.replacingOccurrences(of: "com.adobe.eventSource.", with: "") }
    }

    private(set) var entries: [Entry] = []

    func record(name: String, type: String, source: String, payload: String) {
        entries.insert(Entry(name: name, type: type, source: source, payload: payload), at: 0)
        if entries.count > 300 { entries.removeLast() }   // cap the buffer
    }

    func clear() { entries.removeAll() }
}
