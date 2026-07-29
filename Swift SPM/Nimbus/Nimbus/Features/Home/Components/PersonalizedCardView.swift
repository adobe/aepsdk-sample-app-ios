//
//  PersonalizedCardView.swift
//  Nimbus
//
//  Renders one Optimize decision-scope proposition.
//

import SwiftUI

struct PersonalizedCardView: View {
    let proposition: Proposition

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Personalized", systemImage: "sparkles")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.tint)

            HStack(spacing: 14) {
                Image(systemName: proposition.imageSystemName)
                    .font(.system(size: 34))
                    .foregroundStyle(.tint)
                    .frame(width: 56, height: 56)

                VStack(alignment: .leading, spacing: 4) {
                    Text(proposition.title).font(.headline)
                    Text(proposition.body).font(.subheadline).foregroundStyle(.secondary)
                }
                Spacer(minLength: 0)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
        .padding(.horizontal, 16)
    }
}
