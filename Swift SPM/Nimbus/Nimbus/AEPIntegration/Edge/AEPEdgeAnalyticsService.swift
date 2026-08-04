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
        let xdm: [String: Any] = ["eventType": "application.action"]
        var freeform: [String: Any] = ["actionName": action]
        data?.forEach { freeform[$0.key] = $0.value }
        Edge.sendEvent(experienceEvent: ExperienceEvent(xdm: xdm, data: freeform))
        Log.debug(label: "Nimbus", "Edge.sendEvent application.action \(action)")
    }

    func trackState(_ state: String, data: [String: String]?) {
        MobileCore.track(state: state, data: data)
        let xdm: [String: Any] = ["eventType": "application.screenView"]
        var freeform: [String: Any] = ["screenName": state]
        data?.forEach { freeform[$0.key] = $0.value }
        Edge.sendEvent(experienceEvent: ExperienceEvent(xdm: xdm, data: freeform))
        Log.debug(label: "Nimbus", "Edge.sendEvent application.screenView \(state)")
    }
}
