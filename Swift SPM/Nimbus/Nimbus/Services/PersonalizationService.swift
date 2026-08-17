//
//  PersonalizationService.swift
//  Nimbus
//
//  Seam for Optimize (Decisioning). Returns app-owned Proposition models. Until
//  Optimize is integrated the impl returns canned content; the real impl will
//  call Optimize.updatePropositions and map OptimizeProposition -> Proposition.
//

protocol PersonalizationService {
    /// `scopes` are decision scope names. Returns one proposition per scope
    /// that produced content (may be fewer than requested).
    func fetchPropositions(scopes: [String]) async -> [Proposition]

    /// Report interactions for a previously fetched proposition (by its id) so
    /// Optimize sends the corresponding Edge tracking events. Keyed by id so the
    /// SDK `Offer` type never crosses the seam into the UI.
    func trackDisplay(_ propositionId: String)
    func trackTap(_ propositionId: String)
}
