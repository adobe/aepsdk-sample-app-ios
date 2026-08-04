//
//  AssuranceView.swift
//  Nimbus
//
//  Dedicated Assurance screen (opened from Profile). Launches a session from a
//  pasted session URL (or the QR/deep link handled in the App). The SDK then
//  presents its own PIN overlay.
//

import SwiftUI

struct AssuranceView: View {
    @Environment(AppEnvironment.self) private var env
    @State private var sessionURL = ""
    @State private var launched = false

    var body: some View {
        Form {
            Section {
                Text("Create a session in Assurance, then scan its QR (opens the app) or paste the session link below.")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                TextField("Session URL (…?adb_validation_sessionid=…)", text: $sessionURL)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .font(.caption)

                Button("Launch session") {
                    let trimmed = sessionURL.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard let url = URL(string: trimmed) else { return }
                    env.diagnostics.startSession(url: url)
                    launched = true
                }
                .disabled(sessionURL.trimmingCharacters(in: .whitespaces).isEmpty)
            }

            if launched {
                Section {
                    Label("Session launched — enter the PIN in the Assurance overlay.",
                          systemImage: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundStyle(.green)
                }
            }
        }
        .navigationTitle("Assurance")
        .navigationBarTitleDisplayMode(.inline)
    }
}
