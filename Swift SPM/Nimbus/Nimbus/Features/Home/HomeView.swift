//
//  HomeView.swift
//  Nimbus
//
//  Personalization surface: status strip · personalized card (Optimize) ·
//  content cards (AJO). Commerce moved to the Shop tab. Inspection now lives
//  in the dedicated SDK Event Log screen (Profile).
//

import SwiftUI

struct HomeView: View {
    @Environment(AppEnvironment.self) private var env
    @State private var model = HomeViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 20) {
                        personalizedSection
                        if !model.contentCards.isEmpty {
                            ContentCardCarouselView(cards: model.contentCards)
                        }
                        sdkContentCardsSection
                    }
                    .padding(.vertical, 16)
                }
            }
            .navigationTitle("Home")
            .task { await model.onAppear(env) }
            .onAppear { env.analytics.trackState("home", data: nil) }
            .refreshable { await model.refresh(env) }
        }
    }

    // Same surface as the custom carousel above, rendered via the SDK's
    // templated UI (getContentCardsUI) — demonstrates both rendering APIs.
    private var sdkContentCardsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("SDK Content Cards")
                .font(.headline)
                .padding(.horizontal, 16)
            SDKContentCardsView(surfacePath: SurfaceURI.home)
                .padding(.horizontal, 16)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    private var personalizedSection: some View {
        if let proposition = model.personalized {
            PersonalizedCardView(proposition: proposition)
        } else if model.isLoading {
            ProgressView().frame(maxWidth: .infinity).padding(.vertical, 20)
        } else {
            // Explicit empty state — real personalization returns nothing until
            // consent = yes and a Decisioning activity is configured.
            emptyCard("No personalized content", "Grant consent and configure a decision scope.")
        }
    }

    private func emptyCard(_ title: String, _ subtitle: String) -> some View {
        VStack(spacing: 6) {
            Text(title).font(.subheadline.weight(.medium))
            Text(subtitle).font(.caption).foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
        .padding(.horizontal, 16)
    }
}
