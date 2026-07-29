//
//  LiveActivityManager.swift
//  Nimbus
//
//  Real LiveActivityService. Starts/ends an order-tracking Live Activity via
//  ActivityKit. The SDK observes it (registered in AEPBootstrapper) to sync
//  push-to-start and update tokens to AJO, which can then drive updates and
//  push-to-start remotely.
//

import Foundation
import ActivityKit
import AEPMessagingLiveActivity
import AEPServices

final class LiveActivityManager: LiveActivityService {

    func startOrderTracking() async -> Bool {
        // Live Activities can be disabled by the user / unsupported (Simulator
        // is limited; push-to-start needs a physical iOS 17.2+ device).
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            Log.debug(label: "Nimbus", "Live Activities not enabled on this device")
            return false
        }

        let attributes = OrderActivityAttributes(
            liveActivityData: LiveActivityData(liveActivityID: "order-\(Int.random(in: 1000...9999))"),
            orderNumber: "1234"
        )
        let initialState = OrderActivityAttributes.ContentState(status: "Preparing", etaMinutes: 20)

        do {
            _ = try Activity.request(
                attributes: attributes,
                content: .init(state: initialState, staleDate: nil)
            )
            Log.debug(label: "Nimbus", "Live Activity started (order \(attributes.orderNumber))")
            return true
        } catch {
            Log.debug(label: "Nimbus", "Live Activity start failed: \(error.localizedDescription)")
            return false
        }
    }

    func endOrderTracking() async {
        for activity in Activity<OrderActivityAttributes>.activities {
            await activity.end(nil, dismissalPolicy: .immediate)
        }
        Log.debug(label: "Nimbus", "Live Activity ended")
    }
}
