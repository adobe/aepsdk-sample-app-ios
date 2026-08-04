//
//  LiveActivityCardView.swift
//  Nimbus
//
//  Entry point for the Live Activities demo. The order is mock data; the
//  start/update/end runs through ActivityKit + AEPMessagingLiveActivity.
//

import SwiftUI

struct LiveActivityCardView: View {
    let isActive: Bool
    let onToggle: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Live Activity", systemImage: "bolt.horizontal.circle.fill")
                .font(.headline)

            Text(isActive
                 ? "Order tracking is active on the Lock Screen / Dynamic Island."
                 : "Start a mock order to demo a Live Activity.")
                .font(.caption)
                .foregroundStyle(.secondary)

            Button(isActive ? "End order tracking" : "Start order-tracking demo",
                   action: onToggle)
                .buttonStyle(.borderedProminent)
                .tint(isActive ? .red : .accentColor)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
        .padding(.horizontal, 16)
    }
}
