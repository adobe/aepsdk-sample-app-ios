//
//  Proposition.swift
//  AEPSampleApp
//
//  App-owned model for personalized content (Optimize decision scopes AND
//  AJO content cards). SDK proposition types (OptimizeProposition /
//  ContentCardUI) are mapped INTO this at the integration boundary so the
//  UI stays SDK-agnostic and version bumps don't ripple into views.
//

struct Proposition: Identifiable, Hashable {
    let id: String
    let title: String
    let body: String
    let imageSystemName: String
}
