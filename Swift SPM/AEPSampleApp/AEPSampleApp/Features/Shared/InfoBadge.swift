//
//  InfoBadge.swift
//  AEPSampleApp
//
//  The small "ⓘ" affordance placed on any SDK-driven surface. Tapping it is
//  what opens an InspectorSheet at the call site.
//

import SwiftUI

struct InfoBadge: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "info.circle")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.secondary)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Inspect SDK payload")
    }
}
