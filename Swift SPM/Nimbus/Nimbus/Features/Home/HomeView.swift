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
                        personalizedOffers
                        offersEmptyState
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

    /// One "Recommended for you" block containing an engine-labeled group per
    /// engine (AJO / Target), stacked one below the other.
    @ViewBuilder
    private var personalizedOffers: some View {
        if !model.ajoOffers.isEmpty || !model.targetOffers.isEmpty {
            VStack(alignment: .leading, spacing: 16) {
                Text("Recommended for you")
                    .font(.title3.weight(.semibold))
                    .padding(.horizontal, 16)

                offerGroup("Personalized · Offer Decisioning", offers: model.ajoOffers)
                offerGroup("Personalized · Adobe Target", offers: model.targetOffers)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    /// A labeled group of offers from a single engine. Each offer reports display
    /// on appear and tap on tap through the Optimize seam.
    @ViewBuilder
    private func offerGroup(_ label: String, offers: [Proposition]) -> some View {
        if !offers.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                Text(label)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 16)

                ForEach(offers) { offer in
                    PersonalizedCardView(proposition: offer)
                        .contentShape(Rectangle())
                        .onAppear { env.personalization.trackDisplay(offer.id) }
                        .onTapGesture { env.personalization.trackTap(offer.id) }
                }
            }
        }
    }

    @ViewBuilder
    private var offersEmptyState: some View {
        if model.ajoOffers.isEmpty && model.targetOffers.isEmpty {
            if model.isLoading {
                ProgressView().frame(maxWidth: .infinity).padding(.vertical, 20)
            } else {
                emptyCard("No offers to show",
                          "Add an AJO decision scope or Target activity in Profile → Optimize Offers.")
            }
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
