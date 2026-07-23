//
//  PersonalizedCardView.swift
//  AEPSampleApp
//
//  Renders one Optimize decision-scope proposition. The InfoBadge opens the
//  InspectorSheet so the raw proposition is visible during a demo.
//

import SwiftUI

struct PersonalizedCardView: View {
    let proposition: Proposition
    let onInspect: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("Personalized", systemImage: "sparkles")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.tint)
                Spacer()
                InfoBadge(action: onInspect)
            }

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
