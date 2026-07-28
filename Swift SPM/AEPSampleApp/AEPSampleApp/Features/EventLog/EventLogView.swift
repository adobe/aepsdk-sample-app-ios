//
//  EventLogView.swift
//  AEPSampleApp
//
//  Dedicated SDK Event Log screen (opened from Profile). Renders the real SDK
//  event stream captured by SDKEventRecorder. Tapping a row opens a detail
//  screen with the full payload. An in-app companion to Assurance.
//

import SwiftUI

struct EventLogView: View {
    private let log = EventLog.shared
    @State private var query = ""

    private var filtered: [EventLog.Entry] {
        guard !query.isEmpty else { return log.entries }
        let q = query.lowercased()
        return log.entries.filter {
            $0.name.lowercased().contains(q) ||
            $0.shortType.lowercased().contains(q) ||
            $0.shortSource.lowercased().contains(q)
        }
    }

    var body: some View {
        List {
            if log.entries.isEmpty {
                ContentUnavailableView(
                    "No SDK events yet",
                    systemImage: "dot.radiowaves.left.and.right",
                    description: Text("Interact with the app to see live SDK events.")
                )
            } else {
                ForEach(filtered) { entry in
                    NavigationLink {
                        EventLogDetailView(entry: entry)
                    } label: {
                        row(entry)
                    }
                }
            }
        }
        .navigationTitle("SDK Event Log")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $query, prompt: "Filter events")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Clear") { log.clear() }
                    .disabled(log.entries.isEmpty)
            }
        }
    }

    private func row(_ entry: EventLog.Entry) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(entry.name)
                .font(.subheadline.weight(.medium))
            HStack(spacing: 6) {
                tag(entry.shortType)
                tag(entry.shortSource)
                Spacer()
                Text(entry.time, style: .time)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
        }
    }

    private func tag(_ text: String) -> some View {
        Text(text)
            .font(.caption2.monospaced())
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(Capsule().fill(Color(.secondarySystemBackground)))
            .foregroundStyle(.secondary)
    }
}
