//
//  HomeViewModel.swift
//  Nimbus
//
//  Home personalization surfaces: Optimize offers from two engines — AJO Offer
//  Decisioning and Adobe Target (scopes configured in the Profile lab) — plus
//  the AJO content cards. Commerce lives in the Shop tab (ShopViewModel).
//

import Observation

@Observable
final class HomeViewModel {

    private(set) var ajoOffers: [Proposition] = []
    private(set) var targetOffers: [Proposition] = []
    private(set) var contentCards: [Proposition] = []
    private(set) var isLoading = false

    /// The scope config we last loaded for. onAppear reloads when it changes
    /// (e.g. a scope was set in the Optimize lab), not on every tab switch.
    private var loadedScopes: String?

    func onAppear(_ env: AppEnvironment) async {
        let scopes = OptimizeScopeStore.ajoScope + "|" + OptimizeScopeStore.targetActivity
        guard !isLoading, scopes != loadedScopes else { return }
        await refresh(env)
    }

    func refresh(_ env: AppEnvironment) async {
        isLoading = true
        // Offer scopes come from the locally-saved Optimize config (Profile lab).
        let ajo = OptimizeScopeStore.ajoScope
        let target = OptimizeScopeStore.targetActivity
        async let ajoResult = ajo.isEmpty ? [] : env.personalization.fetchPropositions(scopes: [ajo])
        async let targetResult = target.isEmpty ? [] : env.personalization.fetchPropositions(scopes: [target])
        ajoOffers = await ajoResult
        targetOffers = await targetResult
        // Content cards are fetched once — skip if we already have them.
        if contentCards.isEmpty {
            contentCards = await env.messaging.fetchContentCards(surface: SurfaceURI.home)
        }
        loadedScopes = ajo + "|" + target
        isLoading = false
    }
}
