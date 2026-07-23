//
//  PersonalizationService.swift
//  AEPSampleApp
//
//  Seam for Optimize (Decisioning). Returns app-owned Proposition models. The
//  mock returns canned content; Stage 4 calls Optimize.updatePropositions and
//  maps OptimizeProposition -> Proposition at the boundary.
//

import Foundation

protocol PersonalizationService {
    /// `scopes` are decision scope names. Returns one proposition per scope
    /// that produced content (may be fewer than requested).
    func fetchPropositions(scopes: [String]) async -> [Proposition]
}
