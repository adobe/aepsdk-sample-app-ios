//
//  MockAnalyticsService.swift
//  AEPSampleApp
//
//  Stage 0 impl: logs the event only. No network, no SDK.
//

import Foundation

struct MockAnalyticsService: AnalyticsService {
    func track(_ event: CommerceEvent) {
        // STAGE 1: replace with Edge.sendEvent(ExperienceEvent(xdm: ...))
        // built by XDMEventBuilder and validated against the Shubham Test Schema.
        Log.sdk("track \(event.type.rawValue) — \(event.productName ?? "n/a")")
    }

    func trackAction(_ action: String, data: [String: String]?) {
        Log.sdk("trackAction \(action) (mock)")
    }
}
