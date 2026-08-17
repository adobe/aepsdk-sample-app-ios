//
//  LiveActivityManager.swift
//  Nimbus
//
//  Real LiveActivityService. Starts/advances/ends an order-tracking Live
//  Activity via ActivityKit. The SDK observes it (registered in
//  AEPBootstrapper) to sync push-to-start and update tokens to AJO, which
//  can then drive step updates remotely via a content-state push:
//
//    "content-state": { "step": 3, "etaMinutes": 5 }
//

import Foundation
import ActivityKit
import AEPMessagingLiveActivity
import AEPServices

final class LiveActivityManager: LiveActivityService {

    func startOrderTracking() async -> Bool {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            Log.debug(label: "Nimbus", "Live Activities not enabled on this device")
            return false
        }

        let attributes = OrderActivityAttributes(
            liveActivityData: LiveActivityData(liveActivityID: "order-\(Int.random(in: 1000...9999))"),
            orderNumber: String(Int.random(in: 1000...9999))
        )
        let initialState = OrderActivityAttributes.ContentState(step: .placed, etaMinutes: 30)

        do {
            _ = try Activity.request(
                attributes: attributes,
                content: .init(state: initialState, staleDate: nil),
                pushType: .token
            )
            Log.debug(label: "Nimbus", "Live Activity started — order #\(attributes.orderNumber)")
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

    func advanceStep() async -> OrderStep? {
        guard let activity = Activity<OrderActivityAttributes>.activities.first else { return nil }
        let current = activity.content.state
        guard let next = current.step.next else { return nil }

        let newETA = max(0, current.etaMinutes - 5)
        let newState = OrderActivityAttributes.ContentState(step: next, etaMinutes: newETA)
        await activity.update(.init(state: newState, staleDate: nil))
        Log.debug(label: "Nimbus", "Live Activity advanced → \(next.label) (ETA \(newETA) min)")
        return next
    }

    func currentStep() -> OrderStep? {
        Activity<OrderActivityAttributes>.activities.first?.content.state.step
    }

    // Streams step changes from ActivityKit itself — so a change made by anything
    // OTHER than our local advanceStep() (namely a remote AJO content-state push)
    // still reaches the app. Without this, only the OS Dynamic Island / Lock
    // Screen would update on a remote push; the in-app card would go stale.
    func stepUpdates() -> AsyncStream<OrderStep?> {
        AsyncStream { continuation in
            let supervisor = Task {
                await withTaskGroup(of: Void.self) { group in
                    // Activities already running (e.g. app relaunched mid-order).
                    for activity in Activity<OrderActivityAttributes>.activities {
                        group.addTask { await Self.follow(activity, continuation) }
                    }
                    // Activities started after we subscribed.
                    for await activity in Activity<OrderActivityAttributes>.activityUpdates {
                        group.addTask { await Self.follow(activity, continuation) }
                    }
                }
            }
            continuation.onTermination = { _ in supervisor.cancel() }
        }
    }

    /// Follows one activity: emits its current step, then every content-state
    /// change (local or remote push), and nil once it ends.
    private static func follow(
        _ activity: Activity<OrderActivityAttributes>,
        _ continuation: AsyncStream<OrderStep?>.Continuation
    ) async {
        continuation.yield(activity.content.state.step)
        await withTaskGroup(of: Void.self) { group in
            group.addTask {
                for await content in activity.contentUpdates {
                    continuation.yield(content.state.step)
                }
            }
            group.addTask {
                for await state in activity.activityStateUpdates
                where state == .ended || state == .dismissed {
                    continuation.yield(nil)
                }
            }
        }
    }

    func activeActivities() -> [ActiveActivityInfo] {
        Activity<OrderActivityAttributes>.activities.map { activity in
            ActiveActivityInfo(
                id: activity.id,
                orderNumber: activity.attributes.orderNumber,
                liveActivityID: activity.attributes.liveActivityData.liveActivityID ?? activity.id,
                step: activity.content.state.step,
                etaMinutes: activity.content.state.etaMinutes
            )
        }
    }
}
