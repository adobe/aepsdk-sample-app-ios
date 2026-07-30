//
//  OrderActivityAttributes.swift
//  Nimbus
//
//  Shared Live Activity type — compiled into BOTH the app target and the
//  OrderActivityWidget extension. Conforms to AEPMessagingLiveActivity's
//  LiveActivityAttributes so the SDK can collect push-to-start / update tokens
//  and drive it remotely from AJO.
//
//  ⚠️ Target membership: this one file must belong to BOTH targets (app +
//  widget). Check both boxes in the File Inspector after adding the widget.
//

import ActivityKit
import AEPMessagingLiveActivity

struct OrderActivityAttributes: LiveActivityAttributes {
    // Required by AEPMessagingLiveActivity — ties the activity to an AJO
    // liveActivityID (individual) or channelID (broadcast).
    var liveActivityData: LiveActivityData

    // Static attributes (don't change over the activity's life).
    var orderNumber: String

    // Dynamic state pushed/updated over the activity's life.
    struct ContentState: Codable, Hashable {
        var status: String      // e.g. "Preparing", "Out for delivery", "Delivered"
        var etaMinutes: Int
    }
}

// Lets the Assurance Live Activity plugin validate this schema and trigger test
// start/update/end without hand-built payloads. Returns a representative sample.
extension OrderActivityAttributes: LiveActivityAssuranceDebuggable {
    static func getDebugInfo() -> (attributes: Self, state: ContentState) {
        (
            OrderActivityAttributes(
                liveActivityData: LiveActivityData(liveActivityID: "order-debug"),
                orderNumber: "1234"
            ),
            ContentState(status: "Preparing", etaMinutes: 20)
        )
    }
}
