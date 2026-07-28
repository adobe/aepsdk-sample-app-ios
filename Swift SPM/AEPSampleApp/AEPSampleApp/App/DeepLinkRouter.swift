//
//  DeepLinkRouter.swift
//  AEPSampleApp
//
//  Routes in-app deep links from content-card / message CTAs (custom-action
//  scenario). A CTA whose actionURL uses the `aepsampleapp://` scheme is
//  handled here (e.g. switches tab) instead of being opened externally by the
//  SDK. Drives the TabView selection in RootView.
//

import Foundation
import Observation

@MainActor
@Observable
final class DeepLinkRouter {
    static let shared = DeepLinkRouter()
    private init() {}

    enum Tab: Hashable { case home, shop, inbox, profile }

    static let scheme = "aepsampleapp"

    var selectedTab: Tab = .home

    /// Routes a deep link. Returns true if handled in-app (so the SDK won't
    /// open it externally). e.g. aepsampleapp://shop → switch to the Shop tab.
    @discardableResult
    func handle(_ url: URL) -> Bool {
        guard url.scheme == Self.scheme else { return false }
        switch url.host {
        case "home":    selectedTab = .home
        case "shop":    selectedTab = .shop
        case "inbox":   selectedTab = .inbox
        case "profile": selectedTab = .profile
        default:        return false
        }
        Log.ui("deep link handled -> \(url.host ?? "?")")
        return true
    }
}
