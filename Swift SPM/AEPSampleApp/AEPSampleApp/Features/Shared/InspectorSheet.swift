//
//  InspectorSheet.swift
//  AEPSampleApp
//
//  THE reusable "show me the SDK plumbing" component. Every personalized /
//  messaged element (personalized card, content cards, inbox rows, cart badge)
//  presents one of these with its raw payload, source, and tracking calls.
//  Building this once here is what makes the app richer than a bare sample.
//

import SwiftUI

struct InspectorSheet: View {
    let payload: InspectorPayload

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    section("Source") {
                        Text(payload.source)
                            .font(.system(.subheadline, design: .monospaced))
                            .foregroundStyle(.secondary)
                    }

                    section("Raw payload") {
                        Text(payload.json)
                            .font(.system(.caption, design: .monospaced))
                            .textSelection(.enabled)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(Color(.secondarySystemBackground))
                            )
                    }

                    if !payload.tracking.isEmpty {
                        section("Tracking fired") {
                            VStack(alignment: .leading, spacing: 6) {
                                ForEach(payload.tracking, id: \.self) { line in
                                    Label(line, systemImage: "dot.radiowaves.up.forward")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }
                .padding(20)
            }
            .navigationTitle(payload.title)
            .navigationBarTitleDisplayMode(.inline)
        }
        .presentationDetents([.medium, .large])
    }

    @ViewBuilder
    private func section(_ title: String, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title.uppercased())
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.tertiary)
            content()
        }
    }
}
