//
//  MockPersonalizationService.swift
//  AEPSampleApp
//
//  Stage 0 impl: canned propositions with a simulated fetch delay so the UI
//  exercises real loading states.
//

import Foundation

struct MockPersonalizationService: PersonalizationService {
    func fetchPropositions(scopes: [String]) async -> [Proposition] {
        // STAGE 4: Optimize.updatePropositions(for: scopes.map { DecisionScope(name: $0) })
        // then map each OptimizeProposition -> Proposition.
        try? await Task.sleep(for: .milliseconds(600))
        Log.sdk("fetchPropositions scopes=\(scopes)")

        return scopes.contains("home-banner") ? [
            Proposition(
                id: "mock-home-banner",
                scope: "home-banner",
                title: "Summer picks, just for you",
                body: "A personalized hero selected by Offer Decisioning.",
                imageSystemName: "sparkles",
                rawJSON: #"{ "scope": "home-banner", "items": [{ "id": "xcore:offer:mock", "content": "Summer picks, just for you" }] }"#
            )
        ] : []
    }
}
