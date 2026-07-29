//
//  EventLogDetailView.swift
//  Nimbus
//
//  Detail for a single captured SDK event: metadata + the full payload, with a
//  Copy button for the payload.
//

import SwiftUI
import UIKit

struct EventLogDetailView: View {
    let entry: EventLog.Entry
    @State private var copied = false

    var body: some View {
        List {
            Section("Event") {
                LabeledContent("Name", value: entry.name)
                LabeledContent("Type", value: entry.shortType)
                LabeledContent("Source", value: entry.shortSource)
                LabeledContent("Time", value: entry.time.formatted(date: .omitted, time: .standard))
            }

            Section {
                Text(entry.payload)
                    .font(.system(.caption, design: .monospaced))
                    .textSelection(.enabled)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } header: {
                HStack {
                    Text("Payload")
                    Spacer()
                    Button {
                        UIPasteboard.general.string = entry.payload
                        copied = true
                    } label: {
                        Label(copied ? "Copied" : "Copy",
                              systemImage: copied ? "checkmark" : "doc.on.doc")
                            .font(.caption)
                    }
                }
            }
        }
        .navigationTitle(entry.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
