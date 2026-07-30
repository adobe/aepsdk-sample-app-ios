//
//  SDKEventRecorder.swift
//  Nimbus
//
//  Registers a wildcard event-hub listener so EVERY event the AEP SDK
//  dispatches (Edge requests/responses, consent, identity, lifecycle,
//  messaging propositions, …) is captured into the in-app EventLog. This is
//  what powers the dedicated SDK Event Log screen — a local mini-Assurance.
//

import Foundation
import AEPCore

enum SDKEventRecorder {

    static func start() {
        MobileCore.registerEventListener(type: EventType.wildcard, source: EventSource.wildcard) { event in
            let payload = prettyJSON(event.data)
            Task { @MainActor in
                EventLog.shared.record(
                    name: event.name,
                    type: event.type,
                    source: event.source,
                    payload: payload
                )
            }
        }
    }

    private static func prettyJSON(_ data: [String: Any]?) -> String {
        guard let data, !data.isEmpty else { return "{ }" }
        // `JSONSerialization.data` raises an ObjC *exception* (not a Swift error,
        // so `try?` can't catch it) when the graph holds a non-JSON value like a
        // boxed Swift type — e.g. the Live Activity debug-schema event. Validate
        // first so any such event degrades to a description instead of crashing.
        guard JSONSerialization.isValidJSONObject(data),
              let json = try? JSONSerialization.data(withJSONObject: data, options: [.prettyPrinted, .sortedKeys]),
              let string = String(data: json, encoding: .utf8)
        else { return "\(data)" }
        return string
    }
}
