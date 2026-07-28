//
//  SDKEventRecorder.swift
//  AEPSampleApp
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
        guard
            let json = try? JSONSerialization.data(withJSONObject: data, options: [.prettyPrinted, .sortedKeys]),
            let string = String(data: json, encoding: .utf8)
        else { return "\(data)" }
        return string
    }
}
