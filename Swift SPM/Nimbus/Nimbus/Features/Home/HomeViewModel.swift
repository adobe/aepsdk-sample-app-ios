//
//  HomeViewModel.swift
//  Nimbus
//
//  Home now focuses purely on personalization surfaces: the Optimize
//  decision-scope banner and the AJO content cards. Commerce lives in the
//  Shop tab (ShopViewModel).
//

import Observation

@Observable
final class HomeViewModel {

    private(set) var personalized: Proposition?
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
        // Two independent SDK-backed surfaces fetched concurrently.
        async let banner = env.personalization.fetchPropositions(scopes: ["home-banner"])
        async let cards = env.messaging.fetchContentCards(surface: SurfaceURI.home)
        personalized = await banner.first
        contentCards = await cards
        isLoading = false
    }
}
