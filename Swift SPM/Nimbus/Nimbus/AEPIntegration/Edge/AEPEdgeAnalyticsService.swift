//
//  AEPEdgeAnalyticsService.swift
//  Nimbus
//
//  Real AnalyticsService: dispatches each CommerceEvent as an Edge
//  ExperienceEvent using the structured XDM already built by CommerceXDM
//  (validated against the Shubham Test Schema on ingest).
//

import AEPCore
import AEPEdge
import AEPServices

struct AEPEdgeAnalyticsService: AnalyticsService {
    func track(_ event: CommerceEvent) {
        let experienceEvent = ExperienceEvent(xdm: event.xdm)
        Edge.sendEvent(experienceEvent: experienceEvent)
        Log.debug(label: "Nimbus", "Edge.sendEvent \(event.type.rawValue)")
    }

    func trackAction(_ action: String, data: [String: String]?) {
        MobileCore.track(action: action, data: data)
        Log.debug(label: "Nimbus", "MobileCore.track(action: \(action))")
    }

    func trackState(_ state: String, data: [String: String]?) {
        MobileCore.track(state: state, data: data)
        Log.debug(label: "Nimbus", "MobileCore.track(state: \(state))")
    }
}
