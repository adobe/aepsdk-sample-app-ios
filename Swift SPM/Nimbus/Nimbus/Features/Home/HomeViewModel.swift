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

    private var loaded = false

    func onAppear(_ env: AppEnvironment) async {
        guard !loaded else { return }
        loaded = true
        await refresh(env)
    }

    func refresh(_ env: AppEnvironment) async {
        isLoading = true
        // Offer scopes come from the locally-saved Optimize config (Profile lab).
        let ajo = OptimizeScopeStore.ajoScope
        let target = OptimizeScopeStore.targetActivity
        async let ajoResult = ajo.isEmpty ? [] : env.personalization.fetchPropositions(scopes: [ajo])
        async let targetResult = target.isEmpty ? [] : env.personalization.fetchPropositions(scopes: [target])
        async let cards = env.messaging.fetchContentCards(surface: SurfaceURI.home)
        ajoOffers = await ajoResult
        targetOffers = await targetResult
        contentCards = await cards
        isLoading = false
    }
}
