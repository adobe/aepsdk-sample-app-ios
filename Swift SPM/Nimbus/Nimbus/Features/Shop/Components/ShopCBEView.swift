//
//  ShopCBEView.swift
//  Nimbus
//
//  Renders AJO Code-Based Experiences (JSON) for the selected Shop category
//  surface. Unlike content cards (SDK templated `getContentCardsUI`), CBE is
//  raw proposition content the app fetches via `getPropositionsForSurfaces`
//  and renders itself. SDK-agnostic — goes through the MessagingService seam.
//

import SwiftUI

struct ShopCBEView: View {
    @Environment(AppEnvironment.self) private var env
    let surfacePath: String

    @State private var items: [Proposition] = []
    @State private var isLoading = true

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if isLoading {
                ProgressView().frame(maxWidth: .infinity).padding(.vertical, 8)
            } else if !items.isEmpty {
                Text("Featured")
                    .font(.headline)
                ForEach(items) { item in
                    card(item)
                        .contentShape(Rectangle())
                        .onAppear { env.messaging.trackCBEDisplay(item.id) }
                        .onTapGesture { env.messaging.trackCBEInteract(item.id) }
                }
            }
            // Empty surface → render nothing.
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        // Reload whenever the category surface changes.
        .task(id: surfacePath) { await load() }
    }

    private func card(_ item: Proposition) -> some View {
        HStack(spacing: 12) {
            Image(systemName: item.imageSystemName)
                .font(.title2)
                .foregroundStyle(.tint)
                .frame(width: 44, height: 44)
            VStack(alignment: .leading, spacing: 3) {
                Text(item.title).font(.subheadline.weight(.medium))
                if !item.body.isEmpty {
                    Text(item.body).font(.caption).foregroundStyle(.secondary)
                }
            }
            Spacer(minLength: 0)
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(Color(.secondarySystemBackground)))
    }

    private func load() async {
        isLoading = true
        items = await env.messaging.fetchCodeBasedExperiences(surface: surfacePath)
        isLoading = false
    }
}
