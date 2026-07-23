//
//  InboxRowView.swift
//  AEPSampleApp
//
//  One inbox/feed message. Unread rows show a filled dot; tapping inspects.
//

import SwiftUI

struct InboxRowView: View {
    let message: InboxMessage
    let onInspect: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Circle()
                .fill(message.isRead ? Color.clear : Color.accentColor)
                .frame(width: 8, height: 8)
                .padding(.top, 6)

            VStack(alignment: .leading, spacing: 4) {
                Text(message.title)
                    .font(.subheadline.weight(message.isRead ? .regular : .semibold))
                Text(message.body)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(message.receivedAt, style: .relative)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }

            Spacer(minLength: 0)
            InfoBadge(action: onInspect)
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
    }
}
