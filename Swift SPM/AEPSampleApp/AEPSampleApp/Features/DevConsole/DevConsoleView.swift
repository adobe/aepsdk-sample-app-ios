//
//  DevConsoleView.swift
//  AEPSampleApp
//
//  Hidden QA surface. Assurance session launch + a live in-app log of the
//  app's own SDK calls + the registered-extensions panel. Assurance's full
//  event stream appears in its web UI once connected.
//

import SwiftUI

struct DevConsoleView: View {
    @Environment(AppEnvironment.self) private var env
    @Environment(\.dismiss) private var dismiss
    @State private var model = DevConsoleViewModel()
    @State private var sessionURL = ""

    private let log = EventLog.shared

    var body: some View {
        NavigationStack {
            List {
                assuranceSection
                inAppSection
                eventLogSection
                extensionsSection
            }
            .navigationTitle("Dev Console")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    private var assuranceSection: some View {
        Section("Assurance") {
            Text("Create a session in Assurance, then scan its QR (opens the app) or paste the session link below.")
                .font(.caption)
                .foregroundStyle(.secondary)

            TextField("Session URL (…?adb_validation_sessionid=…)", text: $sessionURL)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .font(.caption)

            Button("Launch session") {
                model.connect(urlString: sessionURL, env)
            }
            .disabled(sessionURL.isEmpty)

            if model.launched {
                Label("Session launched — enter the PIN in the Assurance overlay.",
                      systemImage: "checkmark.circle.fill")
                    .font(.caption)
                    .foregroundStyle(.green)
            }
        }
    }

    private var inAppSection: some View {
        Section {
            Button("Trigger in-app message") {
                // Fires MobileCore.track(action:). Author an AJO in-app campaign
                // triggered by this action to see a message appear.
                env.analytics.trackAction("show-iam", data: nil)
            }
            Button("Refresh in-app definitions") {
                // Manual re-download of AJO in-app campaign definitions.
                env.messaging.refreshInAppMessages()
            }
        } header: {
            Text("In-app messages")
        } footer: {
            Text("Sends the \"show-iam\" action. Requires a matching AJO in-app campaign. Use Refresh after publishing a campaign.")
        }
    }

    private var eventLogSection: some View {
        Section {
            if log.entries.isEmpty {
                Text("No SDK calls yet. Interact with the app to see activity.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(log.entries) { entry in
                    VStack(alignment: .leading, spacing: 2) {
                        Text(entry.message)
                            .font(.system(.caption, design: .monospaced))
                        Text(entry.time, style: .time)
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
                    }
                }
            }
        } header: {
            HStack {
                Text("App SDK calls")
                Spacer()
                if !log.entries.isEmpty {
                    Button("Clear") { log.clear() }
                        .font(.caption)
                }
            }
        } footer: {
            Text("Local companion log. The full SDK event stream appears in the Assurance web UI.")
        }
    }

    private var extensionsSection: some View {
        Section("Registered extensions") {
            ForEach(model.extensions(env)) { ext in
                LabeledContent(ext.name, value: ext.version)
                    .font(.caption)
            }
            LabeledContent("App ID", value: "…launch-665249bfef61-development")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }
}
