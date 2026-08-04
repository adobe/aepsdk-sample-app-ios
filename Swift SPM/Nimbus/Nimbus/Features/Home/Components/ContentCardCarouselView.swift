//
//  ContentCardCarouselView.swift
//  Nimbus
//
//  Horizontally scrollable AJO content cards.
//

import SwiftUI

struct ContentCardCarouselView: View {
    @Environment(AppEnvironment.self) private var env
    let cards: [Proposition]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Featured")
                .font(.headline)
                .padding(.horizontal, 16)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(cards) { card in
                        cardView(card)
                            .onAppear { env.messaging.trackContentCardDisplay(card.id) }
                            .onTapGesture { env.messaging.trackContentCardInteract(card.id) }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }

    private func cardView(_ card: Proposition) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: card.imageSystemName)
                .font(.title2)
                .foregroundStyle(.tint)
            Spacer(minLength: 0)
            Text(card.title).font(.subheadline.weight(.semibold))
            Text(card.body).font(.caption).foregroundStyle(.secondary)
        }
        .padding(14)
        .frame(width: 180, height: 130, alignment: .topLeading)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
    }
}
