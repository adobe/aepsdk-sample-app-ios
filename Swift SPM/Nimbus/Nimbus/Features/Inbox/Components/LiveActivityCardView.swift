//
//  LiveActivityCardView.swift
//  Nimbus
//
//  In-app Live Activity card. Shows the 5-step progress tracker when active,
//  an Advance button to demo step transitions locally (AJO can also push
//  `"content-state": {"step": N, "etaMinutes": M}` to drive the same flow).
//

import SwiftUI

struct LiveActivityCardView: View {
    let isActive: Bool
    let step: OrderStep?
    let canAdvance: Bool
    let onToggle: () -> Void
    let onAdvance: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Label("Live Activity", systemImage: "bolt.horizontal.circle.fill")
                .font(.headline)

            if isActive, let step {
                activeContent(step)
            } else {
                idleContent
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
    }

    // MARK: Active state

    private func activeContent(_ step: OrderStep) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // Progress tracker
            AppStepTrackerView(step: step)

            // Current step badge
            HStack(spacing: 6) {
                Image(systemName: step.systemImage)
                    .foregroundStyle(.orange)
                    .font(.subheadline)
                VStack(alignment: .leading, spacing: 1) {
                    Text(step.label)
                        .font(.subheadline.weight(.semibold))
                    Text(stepSubtitle(step))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }

            // Controls
            HStack(spacing: 10) {
                if canAdvance {
                    Button {
                        onAdvance()
                    } label: {
                        Label("Advance step", systemImage: "arrow.right.circle.fill")
                            .font(.subheadline.weight(.medium))
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.regular)
                }

                Button {
                    onToggle()
                } label: {
                    Label("End", systemImage: "xmark.circle.fill")
                        .font(.subheadline.weight(.medium))
                        .frame(maxWidth: canAdvance ? nil : .infinity)
                }
                .buttonStyle(.bordered)
                .tint(.red)
                .controlSize(.regular)
            }
        }
    }

    // MARK: Idle state

    private var idleContent: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Start a mock order to demo a Live Activity on the Lock Screen and Dynamic Island.")
                .font(.caption)
                .foregroundStyle(.secondary)

            Button("Start order-tracking demo", action: onToggle)
                .buttonStyle(.borderedProminent)
                .controlSize(.regular)
        }
    }

    // MARK: Helpers

    private func stepSubtitle(_ step: OrderStep) -> String {
        switch step {
        case .placed:         return "Order confirmed"
        case .preparing:      return "Kitchen is on it"
        case .packing:        return "Getting packed up"
        case .outForDelivery: return "Rider is on the way"
        case .delivered:      return "Enjoy!"
        }
    }
}

// MARK: - In-app step tracker

/// App-side version of the widget's StepTrackerView. Uses tint + system
/// colors instead of white-on-black (works on both light and dark mode).
struct AppStepTrackerView: View {
    let step: OrderStep

    var body: some View {
        VStack(spacing: 5) {
            HStack(spacing: 0) {
                ForEach(Array(OrderStep.allCases.enumerated()), id: \.offset) { idx, s in
                    dot(s)
                    if idx < OrderStep.allCases.count - 1 {
                        connector(afterStep: s)
                    }
                }
            }
            HStack(spacing: 0) {
                ForEach(OrderStep.allCases, id: \.self) { s in
                    Text(s.label)
                        .font(.system(size: 9))
                        .foregroundStyle(s == step ? .primary : .tertiary)
                        .frame(maxWidth: .infinity)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                        .multilineTextAlignment(.center)
                }
            }
        }
    }

    @ViewBuilder
    private func dot(_ s: OrderStep) -> some View {
        let done    = s.rawValue < step.rawValue
        let current = s == step

        Circle()
            .fill(done ? Color.accentColor : (current ? Color.accentColor.opacity(0.15) : Color(.tertiarySystemFill)))
            .frame(width: 18, height: 18)
            .overlay(Circle().strokeBorder(current ? Color.accentColor : .clear, lineWidth: 2))
            .overlay {
                if done {
                    Image(systemName: "checkmark")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundStyle(.white)
                } else if current {
                    Circle()
                        .fill(Color.accentColor)
                        .frame(width: 8, height: 8)
                }
            }
    }

    private func connector(afterStep s: OrderStep) -> some View {
        Rectangle()
            .fill(s.rawValue < step.rawValue ? Color.accentColor : Color(.tertiarySystemFill))
            .frame(height: 2)
            .frame(maxWidth: .infinity)
    }
}
