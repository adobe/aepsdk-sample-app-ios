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

// MARK: - Order step

/// Five-stage order lifecycle. Raw Int value is what AJO sends in the
/// `content-state` push payload: `"step": 2` → `.packing`.
enum OrderStep: Int, Codable, Hashable, CaseIterable {
    case placed        = 0
    case preparing     = 1
    case packing       = 2
    case outForDelivery = 3
    case delivered     = 4

    var label: String {
        switch self {
        case .placed:         return "Placed"
        case .preparing:      return "Preparing"
        case .packing:        return "Packing"
        case .outForDelivery: return "On the way"
        case .delivered:      return "Delivered"
        }
    }

    var systemImage: String {
        switch self {
        case .placed:         return "checkmark.circle.fill"
        case .preparing:      return "flame.fill"
        case .packing:        return "shippingbox.fill"
        case .outForDelivery: return "bicycle"
        case .delivered:      return "house.circle.fill"
        }
    }

    var isTerminal: Bool { self == .delivered }
    var next: OrderStep? { OrderStep(rawValue: rawValue + 1) }
}

// MARK: - Activity attributes

struct OrderActivityAttributes: LiveActivityAttributes {
    // Required by AEPMessagingLiveActivity — ties the activity to an AJO
    // liveActivityID (individual) or channelID (broadcast).
    var liveActivityData: LiveActivityData

    // Static attributes (unchanged over the activity's life).
    var orderNumber: String

    // Dynamic state pushed/updated over the activity's life.
    struct ContentState: Codable, Hashable {
        var step: OrderStep
        var etaMinutes: Int
    }
}

// Lets the Assurance Live Activity plugin validate this schema and trigger test
// start/update/end without hand-built payloads.
extension OrderActivityAttributes: LiveActivityAssuranceDebuggable {
    static func getDebugInfo() -> (attributes: Self, state: ContentState) {
        (
            OrderActivityAttributes(
                liveActivityData: LiveActivityData(liveActivityID: "order-debug"),
                orderNumber: "1234"
            ),
            ContentState(step: .preparing, etaMinutes: 20)
        )
    }
}
