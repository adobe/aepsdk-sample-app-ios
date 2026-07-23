//
//  ProfileView.swift
//  AEPSampleApp
//
//  Identity (mock login → real updateIdentities), Consent toggle, and push
//  controls. The app version row long-presses to reveal the hidden Dev
//  Console — keeping it a debug tool, not a feature.
//

import SwiftUI

struct ProfileView: View {
    @Environment(AppEnvironment.self) private var env
    @State private var model = ProfileViewModel()
    @State private var username = ""
    @State private var showDevConsole = false

    var body: some View {
        NavigationStack {
            Form {
                identitySection
                consentSection
                notificationsSection
                aboutSection
            }
            .navigationTitle("Profile")
            .task { await model.onAppear(env) }
            .sheet(isPresented: $showDevConsole) { DevConsoleView() }
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
                TextField("Test username", text: $username)
                    .textInputAutocapitalization(.never)
                Button("Log in") {
                    let name = username.trimmingCharacters(in: .whitespaces)
                    guard !name.isEmpty else { return }
                    env.login(username: name)
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
            Button("Send me a test push") { model.sendTestPush(env) }
                .disabled(model.pushStatus != .granted)
        }
    }

    private var aboutSection: some View {
        Section {
            LabeledContent("App version", value: "1.0")
                // Hidden entry to the Dev Console.
                .contentShape(Rectangle())
                .onLongPressGesture { showDevConsole = true }
        } footer: {
            Text("Long-press the version row to open the Dev Console.")
        }
    }
}
