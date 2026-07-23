//
//  HomeView.swift
//  AEPSampleApp
//
//  Personalization surface: status strip · personalized card (Optimize) ·
//  content cards (AJO). Commerce moved to the Shop tab.
//

import SwiftUI

struct HomeView: View {
    @Environment(AppEnvironment.self) private var env
    @State private var model = HomeViewModel()
    @State private var inspector: InspectorPayload?

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                StatusStripView()

                ScrollView {
                    VStack(spacing: 20) {
                        personalizedSection
                        if !model.contentCards.isEmpty {
                            ContentCardCarouselView(cards: model.contentCards) { card in
                                inspector = inspectorPayload(for: card)
                            }
                        }
                    }
                    .padding(.vertical, 16)
                }
            }
            .navigationTitle("Home")
            .task { await model.onAppear(env) }
            .refreshable { await model.refresh(env) }
            .sheet(item: $inspector) { InspectorSheet(payload: $0) }
        }
    }

    @ViewBuilder
    private var personalizedSection: some View {
        if let proposition = model.personalized {
            PersonalizedCardView(proposition: proposition) {
                inspector = inspectorPayload(for: proposition)
            }
        } else if model.isLoading {
            ProgressView().frame(maxWidth: .infinity).padding(.vertical, 20)
        } else {
            // Explicit empty state — real personalization returns nothing until
            // consent = yes and a Decisioning activity is configured (Stage 4).
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

    private func inspectorPayload(for p: Proposition) -> InspectorPayload {
        InspectorPayload(
            title: p.title,
            source: p.scope,
            json: p.rawJSON,
            tracking: ["propositionDisplay", "propositionInteract (on tap)"]
        )
    }
}
