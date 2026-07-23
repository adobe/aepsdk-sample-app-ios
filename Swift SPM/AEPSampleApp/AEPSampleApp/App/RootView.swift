//
//  RootView.swift
//  AEPSampleApp
//
//  Top-level gate: shows the one-time Consent primer on first launch, then
//  the main tab bar. The Dev Console is intentionally NOT a visible tab — it
//  opens from a hidden gesture in Profile.
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
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house.fill") {
                HomeView()
            }
            Tab("Shop", systemImage: "bag.fill") {
                ShopView()
            }
            Tab("Inbox", systemImage: "tray.fill") {
                InboxView()
            }
            Tab("Profile", systemImage: "person.fill") {
                ProfileView()
            }
        }
    }
}
