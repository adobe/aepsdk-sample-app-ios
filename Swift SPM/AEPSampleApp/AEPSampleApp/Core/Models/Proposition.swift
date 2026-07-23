//
//  Proposition.swift
//  AEPSampleApp
//
//  App-owned model for personalized content (Optimize decision scopes AND
//  AJO content cards). SDK proposition types (OptimizeProposition /
//  ContentCardUI) are mapped INTO this at the integration boundary so the
//  UI stays SDK-agnostic and version bumps don't ripple into views.
//

import Foundation

struct Proposition: Identifiable, Hashable {
    let id: String
    let scope: String            // decision scope name OR surface URI
    let title: String
    let body: String
    let imageSystemName: String
    let rawJSON: String          // shown verbatim in the InspectorSheet
}
