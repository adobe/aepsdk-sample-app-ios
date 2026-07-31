//
//  OptimizeOffersView.swift
//  Nimbus
//
//  Developer lab for AEP Optimize. Lets you paste two decision scopes — an AJO
//  Offer Decisioning encoded scope and an Adobe Target activity/mbox name —
//  persist them locally, fetch, and inspect the returned offers. SDK-agnostic:
//  it goes through the PersonalizationService seam (AEPOptimizeService), so no
//  Adobe import here.
//

import SwiftUI

struct OptimizeOffersView: View {
    @Environment(AppEnvironment.self) private var env

    // Inputs are kept locally (UserDefaults) so they survive relaunch and are
    // shared with Home via OptimizeScopeStore's keys.
    @AppStorage(OptimizeScopeStore.ajoKey) private var ajoScope = ""
    @AppStorage(OptimizeScopeStore.targetKey) private var targetActivity = ""

    @State private var ajoOffers: [Proposition] = []
    @State private var targetOffers: [Proposition] = []
    @State private var isLoading = false
    @State private var didFetch = false

    var body: some View {
        Form {
            Section("AJO Offer Decisioning") {
                TextField("Decision scope (encoded)", text: $ajoScope, axis: .vertical)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .font(.caption.monospaced())
                    .lineLimit(1...4)
            }

            Section("Adobe Target") {
                TextField("Activity / mbox name", text: $targetActivity)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            }

            Section {
                Button {
                    Task { await fetch() }
                } label: {
                    HStack {
                        Text("Fetch offers")
                        if isLoading { Spacer(); ProgressView() }
                    }
                }
                .disabled(trimmedScopes.isEmpty || isLoading)
            }

            offerSection("AJO offers", ajoOffers)
            offerSection("Target offers", targetOffers)

            if didFetch && ajoOffers.isEmpty && targetOffers.isEmpty && !isLoading {
                Section {
                    Text("No offers returned. Check the scope, consent, and that the datastream serves this decision.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle("Optimize Offers")
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private func offerSection(_ title: String, _ offers: [Proposition]) -> some View {
        if !offers.isEmpty {
            Section("\(title) (\(offers.count))") {
                ForEach(offers) { offer in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(offer.title).font(.subheadline.weight(.medium))
                        if !offer.body.isEmpty {
                            Text(offer.body).font(.caption).foregroundStyle(.secondary)
                        }
                        Text(offer.id).font(.caption2.monospaced()).foregroundStyle(.tertiary)
                        Text("tap to report click").font(.caption2).foregroundStyle(.tertiary)
                    }
                    .padding(.vertical, 2)
                    .contentShape(Rectangle())
                    .onAppear { env.personalization.trackDisplay(offer.id) }
                    .onTapGesture { env.personalization.trackTap(offer.id) }
                }
            }
        }
    }

    private var trimmedScopes: [String] {
        [ajoScope, targetActivity]
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }

    private func fetch() async {
        isLoading = true
        let ajo = ajoScope.trimmingCharacters(in: .whitespacesAndNewlines)
        let target = targetActivity.trimmingCharacters(in: .whitespacesAndNewlines)
        // Fetch both engines in parallel — the SDK matches each response to its
        // own request, so the two updatePropositions calls are safe to overlap.
        async let ajoResult = ajo.isEmpty ? [] : env.personalization.fetchPropositions(scopes: [ajo])
        async let targetResult = target.isEmpty ? [] : env.personalization.fetchPropositions(scopes: [target])
        ajoOffers = await ajoResult
        targetOffers = await targetResult
        didFetch = true
        isLoading = false
    }
}
