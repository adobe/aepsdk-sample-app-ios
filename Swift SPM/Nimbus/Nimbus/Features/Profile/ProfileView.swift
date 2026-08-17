//
//  ProfileView.swift
//  Nimbus
//
//  Identity (mock login → real updateIdentities), Consent toggle, push
//  controls, and Developer tools (SDK Event Log + Assurance).
//

import SwiftUI

struct ProfileView: View {
    @Environment(AppEnvironment.self) private var env
    @State private var model = ProfileViewModel()
    @State private var username = ""

    var body: some View {
        NavigationStack {
            Form {
                identitySection
                consentSection
                notificationsSection
                developerSection
            }
            .navigationTitle("Profile")
            .onAppear { env.analytics.trackState("profile", data: nil) }
            .task { await model.onAppear(env) }
        }
    }

    // MARK: Sections

    private var identitySection: some View {
        Section("Identity") {
            if let user = env.signedInUser {
                LabeledContent("Linked to", value: user)
                LabeledContent("ECID", value: env.shortECID)
                Button("Log out", role: .destructive) { env.logout() }
            } else {
                LabeledContent("Status", value: "Anonymous")
                LabeledContent("ECID", value: env.shortECID)
                TextField("Email", text: $username)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
                Button("Log in") {
                    let email = username.trimmingCharacters(in: .whitespaces)
                    guard !email.isEmpty else { return }
                    env.login(username: email)
                    username = ""
                }
                .disabled(username.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }
    }

    private var consentSection: some View {
        Section("Consent") {
            Toggle("Allow data collection & personalization", isOn: Binding(
                get: { env.consent == .yes },
                set: { env.updateConsent($0 ? .yes : .no) }
            ))
            LabeledContent("Current state", value: env.consent.rawValue)
        }
    }

    private var notificationsSection: some View {
        Section("Notifications") {
            LabeledContent("Push", value: model.pushStatus.label)
            if model.pushStatus == .notRequested {
                Button("Enable notifications") {
                    Task { await model.requestPush(env) }
                }
            }
        }
    }

    private var developerSection: some View {
        Section("Developer") {
            NavigationLink {
                EventLogView()
            } label: {
                Label("SDK Event Log", systemImage: "dot.radiowaves.left.and.right")
            }
            NavigationLink {
                AssuranceView()
            } label: {
                Label("Assurance", systemImage: "checkmark.shield")
            }
            NavigationLink {
                OptimizeOffersView()
            } label: {
                Label("Optimize Offers", systemImage: "wand.and.stars")
            }
            LabeledContent("App version", value: "1.0")
        }
    }
}
