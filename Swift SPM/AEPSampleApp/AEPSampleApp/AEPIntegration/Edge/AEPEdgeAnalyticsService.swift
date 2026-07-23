//
//  AEPEdgeAnalyticsService.swift
//  AEPSampleApp
//
//  Real AnalyticsService: dispatches each CommerceEvent as an Edge
//  ExperienceEvent using the structured XDM already built by CommerceXDM
//  (validated against the Shubham Test Schema on ingest).
//

import AEPCore
import AEPEdge

struct AEPEdgeAnalyticsService: AnalyticsService {
    func track(_ event: CommerceEvent) {
        let experienceEvent = ExperienceEvent(xdm: event.xdm)
        Edge.sendEvent(experienceEvent: experienceEvent)
        Log.sdk("Edge.sendEvent \(event.type.rawValue)")
    }

    func trackAction(_ action: String, data: [String: String]?) {
        MobileCore.track(action: action, data: data)
        Log.sdk("MobileCore.track(action: \(action))")
    }
}
