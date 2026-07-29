//
//  RootView.swift
//  Nimbus
//
//  Top-level gate: shows the one-time Consent primer on first launch, then the
//  main tab bar. Tab selection is driven by DeepLinkRouter so content-card /
//  message CTA deep links can switch tabs.
//

import SwiftUI

struct RootView: View {
    @Environment(AppEnvironment.self) private var env

    var body: some View {
        if env.hasChosenConsent {
            MainTabView()
        } else {
            ConsentPrimerView()
        }
    }
}

private struct MainTabView: View {
    @State private var router = DeepLinkRouter.shared

    var body: some View {
        TabView(selection: $router.selectedTab) {
            Tab("Home", systemImage: "house.fill", value: DeepLinkRouter.Tab.home) {
                HomeView()
            }
            Tab("Shop", systemImage: "bag.fill", value: DeepLinkRouter.Tab.shop) {
                ShopView()
            }
            Tab("Inbox", systemImage: "tray.fill", value: DeepLinkRouter.Tab.inbox) {
                InboxView()
            }
            Tab("Profile", systemImage: "person.fill", value: DeepLinkRouter.Tab.profile) {
                ProfileView()
            }
        }
    }
}
