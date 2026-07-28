//
//  MockPersonalizationService.swift
//  AEPSampleApp
//
//  Stand-in personalization until Optimize/Decisioning is integrated. Returns a
//  canned hero proposition with a simulated fetch delay so the UI exercises its
//  loading states. Replace with Optimize.updatePropositions when integrated.
//

import Foundation

struct MockPersonalizationService: PersonalizationService {
    func fetchPropositions(scopes: [String]) async -> [Proposition] {
        try? await Task.sleep(for: .milliseconds(600))
        Log.sdk("fetchPropositions scopes=\(scopes)")

        return scopes.contains("home-banner") ? [
            Proposition(
                id: "mock-home-banner",
                title: "Summer picks, just for you",
                body: "A personalized hero selected by Offer Decisioning.",
                imageSystemName: "sparkles"
            )
        ] : []
    }
}
