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
}
