//
//  MockLiveActivityService.swift
//  AEPSampleApp
//
//  Stage 0 impl: pretends to start/end an order activity.
//

import Foundation

struct MockLiveActivityService: LiveActivityService {
    func startOrderTracking() async -> Bool {
        // STAGE 3e: Activity.request(...) with OrderActivityAttributes, then
        // Messaging.registerLiveActivity(...) to sync push tokens to AEP.
        try? await Task.sleep(for: .milliseconds(300))
        Log.sdk("startOrderTracking (mock)")
        return true
    }

    func endOrderTracking() async {
        // STAGE 3e: activity.end(...)
        Log.sdk("endOrderTracking (mock)")
    }
}
