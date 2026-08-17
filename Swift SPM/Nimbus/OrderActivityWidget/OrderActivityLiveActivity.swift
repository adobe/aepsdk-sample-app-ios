//
//  OrderActivityLiveActivity.swift
//  OrderActivityWidget
//
//  Rich 5-step order-tracking Live Activity. Lock Screen shows the full step
//  tracker + ETA header. Dynamic Island (expanded) mirrors it; compact/minimal
//  show the current-step icon + ETA.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct OrderActivityLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: OrderActivityAttributes.self) { context in
            LockScreenView(context: context)
                .activityBackgroundTint(Color.black.opacity(0.88))
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Label("Order #\(context.attributes.orderNumber)",
                          systemImage: "bag.fill")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.white)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    etaLabel(context.state.etaMinutes, step: context.state.step)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    StepTrackerView(step: context.state.step)
                        .padding(.horizontal, 8)
                        .padding(.bottom, 4)
                }
            } compactLeading: {
                Image(systemName: context.state.step.systemImage)
                    .foregroundStyle(.orange)
            } compactTrailing: {
                compactTrailing(context.state)
            } minimal: {
                Image(systemName: context.state.step.systemImage)
                    .foregroundStyle(.orange)
            }
        }
    }

    @ViewBuilder
    private func etaLabel(_ minutes: Int, step: OrderStep) -> some View {
        if step.isTerminal {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)
        } else if minutes > 0 {
            Label("\(minutes) min", systemImage: "clock")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.8))
        }
    }

    @ViewBuilder
    private func compactTrailing(_ state: OrderActivityAttributes.ContentState) -> some View {
        if state.step.isTerminal {
            Image(systemName: "checkmark").foregroundStyle(.green)
        } else if state.etaMinutes > 0 {
            Text("\(state.etaMinutes)m")
                .font(.caption.monospacedDigit())
                .foregroundStyle(.white)
        }
    }
}

// MARK: - Lock Screen layout

private struct LockScreenView: View {
    let context: ActivityViewContext<OrderActivityAttributes>

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Header
            HStack {
                Label("Order #\(context.attributes.orderNumber)",
                      systemImage: "bag.fill")
                    .font(.subheadline.weight(.semibold))
                Spacer()
                if !context.state.step.isTerminal, context.state.etaMinutes > 0 {
                    Label("\(context.state.etaMinutes) min", systemImage: "clock")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.7))
                }
            }

            // 5-step tracker
            StepTrackerView(step: context.state.step)

            // Current step badge
            HStack(spacing: 6) {
                Image(systemName: context.state.step.systemImage)
                    .foregroundStyle(.orange)
                Text(context.state.step.label)
                    .font(.footnote.weight(.semibold))
                Spacer()
            }
        }
        .padding(16)
        .foregroundStyle(.white)
    }
}

// MARK: - Step tracker (shared in widget)

/// Horizontal row of 5 dots connected by lines. Completed → white-filled +
/// checkmark. Current → white dot with orange core. Pending → dimmed outline.
struct StepTrackerView: View {
    let step: OrderStep

    var body: some View {
        VStack(spacing: 5) {
            // Dots + connectors
            HStack(spacing: 0) {
                ForEach(Array(OrderStep.allCases.enumerated()), id: \.offset) { idx, s in
                    dot(s)
                    if idx < OrderStep.allCases.count - 1 {
                        connector(afterStep: s)
                    }
                }
            }
            // Labels
            HStack(spacing: 0) {
                ForEach(OrderStep.allCases, id: \.self) { s in
                    Text(s.label)
                        .font(.system(size: 8))
                        .foregroundStyle(s == step ? .white : .white.opacity(0.4))
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
            .fill(done || current ? Color.white : Color.white.opacity(0.2))
            .frame(width: 16, height: 16)
            .overlay {
                if done {
                    Image(systemName: "checkmark")
                        .font(.system(size: 7, weight: .bold))
                        .foregroundStyle(.black)
                } else if current {
                    Circle()
                        .fill(Color.orange)
                        .frame(width: 8, height: 8)
                }
            }
    }

    private func connector(afterStep s: OrderStep) -> some View {
        Rectangle()
            .fill(s.rawValue < step.rawValue ? Color.white : Color.white.opacity(0.2))
            .frame(height: 2)
            .frame(maxWidth: .infinity)
    }
}
