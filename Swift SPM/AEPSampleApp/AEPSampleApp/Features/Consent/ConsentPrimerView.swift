//
//  ConsentPrimerView.swift
//  AEPSampleApp
//
//  First-launch screen. Proves Edge Consent: the live state line flips the
//  instant a choice is made. Writes through AppEnvironment.chooseConsent,
//  which (Stage 1) calls Consent.update with a real XDM consent payload.
//

import SwiftUI

struct ConsentPrimerView: View {
    @Environment(AppEnvironment.self) private var env

    var body: some View {
        VStack(spacing: 28) {
            Spacer()

            Image(systemName: "hand.raised.circle.fill")
                .font(.system(size: 72))
                .foregroundStyle(.tint)

            VStack(spacing: 10) {
                Text("Personalize your experience")
                    .font(.title.bold())
                    .multilineTextAlignment(.center)

                Text("Allow data collection so we can tailor content and offers to you. You can change this anytime in Profile.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 32)

            Spacer()

            VStack(spacing: 12) {
                Button {
                    env.chooseConsent(.yes)
                } label: {
                    Text("Allow personalization")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)

                Button {
                    env.chooseConsent(.no)
                } label: {
                    Text("Not now")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
            }
            .padding(.horizontal, 24)

            // Live proof the Consent SDK call fired.
            Text("Current consent state: \(env.consent.rawValue)")
                .font(.footnote.monospaced())
                .foregroundStyle(.secondary)
                .padding(.bottom, 24)
        }
    }
}
