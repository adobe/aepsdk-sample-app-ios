//
//  OrderActivityLiveActivity.swift
//  OrderActivityWidget
//
//  The Live Activity UI (Lock Screen + Dynamic Island) for OrderActivityAttributes.
//  This lives in the OrderActivityWidget extension target. The shared
//  OrderActivityAttributes.swift must also be a member of this target.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct OrderActivityLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: OrderActivityAttributes.self) { context in
            // Lock Screen / banner presentation
            lockScreen(context)
                .padding()
                .activityBackgroundTint(Color.black.opacity(0.85))
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Label("Order #\(context.attributes.orderNumber)", systemImage: "shippingbox.fill")
                        .font(.caption.weight(.semibold))
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("\(context.state.etaMinutes) min").font(.caption)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text(context.state.status).font(.headline)
                }
            } compactLeading: {
                Image(systemName: "shippingbox.fill")
            } compactTrailing: {
                Text("\(context.state.etaMinutes)m")
            } minimal: {
                Image(systemName: "shippingbox.fill")
            }
        }
    }

    private func lockScreen(_ context: ActivityViewContext<OrderActivityAttributes>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Label("Order #\(context.attributes.orderNumber)", systemImage: "shippingbox.fill")
                    .font(.subheadline.weight(.semibold))
                Spacer()
                Text("ETA \(context.state.etaMinutes) min").font(.caption)
            }
            Text(context.state.status)
                .font(.headline)
        }
        .foregroundStyle(.white)
    }
}
