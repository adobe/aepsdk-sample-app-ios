//
//  AnalyticsService.swift
//  AEPSampleApp
//
//  Seam for "Analytics via Edge XDM". The UI builds a CommerceEvent and hands
//  it here; the mock just logs it, the real impl (Stage 1) dispatches it via
//  Edge.sendEvent against the Shubham Test Schema.
//

import Foundation

protocol AnalyticsService {
    /// One call == one discrete Edge event. Never batches / accumulates.
    func track(_ event: CommerceEvent)

    /// A named behavioral action (MobileCore.track(action:)). AJO in-app
    /// message rules can trigger on these — e.g. "order-complete".
    func trackAction(_ action: String, data: [String: String]?)

    /// A screen view (MobileCore.track(state:)). AJO in-app rules can trigger
    /// on these — e.g. show a message on the "home" or "cart" screen.
    func trackState(_ state: String, data: [String: String]?)
}
