//
//  LoginView.swift
//  Nimbus
//
//  Second onboarding screen (shown after consent, before main tabs). Calls the
//  same env.login() used in Profile — no duplicate logic. On relaunch the SDK
//  Identity Map is checked; if an authenticated Email item exists this screen
//  is skipped automatically.
//

import SwiftUI

struct LoginView: View {
    @Environment(AppEnvironment.self) private var env
    @State private var email = ""
    @FocusState private var focused: Bool

    private var isValidEmail: Bool {
        let trimmed = email.trimmingCharacters(in: .whitespaces)
        return trimmed.contains("@") && trimmed.count > 2
    }

    var body: some View {
        VStack(spacing: 28) {
            Spacer()

            Image(systemName: "person.circle.fill")
                .font(.system(size: 72))
                .foregroundStyle(.tint)

            VStack(spacing: 10) {
                Text("Sign in to Nimbus")
                    .font(.title.bold())
                    .multilineTextAlignment(.center)

                Text("Link your email so AJO can personalize offers and messages for you.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 32)

            Spacer()

            VStack(spacing: 14) {
                TextField("Email address", text: $email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .focused($focused)
                    .padding(14)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color(.secondarySystemBackground))
                    )

                Button {
                    let trimmed = email.trimmingCharacters(in: .whitespaces)
                    env.login(username: trimmed)
                } label: {
                    Text("Sign in")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(!isValidEmail)

                Button {
                    env.continueAsGuest()
                } label: {
                    Text("Continue as Guest")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
            }
            .padding(.horizontal, 24)

            Text("ECID: \(env.shortECID)")
                .font(.footnote.monospaced())
                .foregroundStyle(.secondary)
                .padding(.bottom, 24)
        }
        .onAppear { focused = true }
    }
}
