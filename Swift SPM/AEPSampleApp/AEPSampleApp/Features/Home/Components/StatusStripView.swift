//
//  StatusStripView.swift
//  AEPSampleApp
//
//  Always-visible ambient proof that Identity + Consent are live: ECID,
//  consent state, and signed-in user. Reads shared state from AppEnvironment.
//

import SwiftUI

struct StatusStripView: View {
    @Environment(AppEnvironment.self) private var env

    var body: some View {
        HStack(spacing: 10) {
            chip(icon: "number", text: env.shortECID)
            chip(icon: "hand.raised", text: env.consent.rawValue)
            chip(icon: "person", text: env.signedInUser ?? "guest")
            Spacer(minLength: 0)
        }
        .font(.caption2.monospaced())
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }

    private func chip(icon: String, text: String) -> some View {
        Label(text, systemImage: icon)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Capsule().fill(Color(.secondarySystemBackground)))
            .foregroundStyle(.secondary)
    }
}
