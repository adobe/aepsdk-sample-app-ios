//
//  AEPOptimizeService.swift
//  Nimbus
//
//  Real PersonalizationService backed by AEP Optimize (AJO Offer Decisioning).
//  Fetches the winning offer per decision scope, maps it to the app's
//  SDK-agnostic Proposition, and reports display/tap interactions to Edge.
//  Wired as the personalization service in AppEnvironment.live().
//

import Foundation
import AEPOptimize
import AEPServices

final class AEPOptimizeService: PersonalizationService {

    // Retains fetched Offers keyed by id so trackDisplay/trackTap can report
    // interactions without exposing `Offer` to the UI. Also retains the parent
    // OptimizeProposition: `Offer.proposition` is `weak`, and tracking builds its
    // XDM from that parent — if it deallocs, tracking fails ("xdmData is nil").
    private var offersById: [String: Offer] = [:]
    private var propositionsById: [String: OptimizeProposition] = [:]

    func fetchPropositions(scopes: [String]) async -> [Proposition] {
        let decisionScopes = scopes.map { DecisionScope(name: $0) }

        // updatePropositions warms the Optimize cache from Edge AND returns the
        // fetched propositions in its completion, so no separate getPropositions
        // read is needed here.
        let propositions: [DecisionScope: OptimizeProposition] = await withCheckedContinuation { continuation in
            Optimize.updatePropositions(for: decisionScopes, withXdm: nil) { props, error in
                if let error {
                    Log.warning(label: "Nimbus", "optimize updatePropositions error: \(error.localizedDescription)")
                }
                continuation.resume(returning: props ?? [:])
            }
        }

        // Diagnostic: how many offers came back per scope (0 = Edge returned no
        // decision for that scope — check the datastream service + Assurance).
        Log.debug(label: "Nimbus", "optimize \(scopes) -> \(propositions.count) proposition(s)")
        for scope in decisionScopes {
            Log.debug(label: "Nimbus", "  scope=\(scope.name) offers=\(propositions[scope]?.offers.count ?? 0)")
        }

        return decisionScopes.compactMap { scope -> Proposition? in
            guard let proposition = propositions[scope], let offer = proposition.offers.first else { return nil }
            offersById[offer.id] = offer
            propositionsById[offer.id] = proposition   // keep weak parent alive for tracking
            return Self.map(offer)
        }
    }

    /// Offer shown on screen → Edge display interaction.
    func trackDisplay(_ propositionId: String) {
        offersById[propositionId]?.displayed()
    }

    /// Offer tapped → Edge tap/click interaction.
    func trackTap(_ propositionId: String) {
        offersById[propositionId]?.tapped()
    }

    /// Offers authored as a JSON object are parsed for title/body/image; any
    /// other content type falls back to the raw content as the body.
    private static func map(_ offer: Offer) -> Proposition {
        if let data = offer.content.data(using: .utf8),
           let obj = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            return Proposition(
                id: offer.id,
                title: obj["title"] as? String ?? "Just for you",
                body: obj["body"] as? String ?? "",
                imageSystemName: obj["image"] as? String ?? "sparkles"
            )
        }
        return Proposition(id: offer.id, title: "Just for you", body: offer.content, imageSystemName: "sparkles")
    }
}
