//
//  ContentCardCarouselView.swift
//  AEPSampleApp
//
//  Horizontally scrollable AJO content cards. Each card carries an InfoBadge.
//

import SwiftUI

struct ContentCardCarouselView: View {
    let cards: [Proposition]
    let onInspect: (Proposition) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Featured")
                .font(.headline)
                .padding(.horizontal, 16)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(cards) { card in
                        cardView(card)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }

    private func cardView(_ card: Proposition) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: card.imageSystemName)
                    .font(.title2)
                    .foregroundStyle(.tint)
                Spacer()
                InfoBadge { onInspect(card) }
            }
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
