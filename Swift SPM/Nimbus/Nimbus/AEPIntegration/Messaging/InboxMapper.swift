//
//  InboxMapper.swift
//  Nimbus
//
//  Maps AEPMessaging proposition items for the inbox surface into the app's
//  InboxMessage model. Read/dismiss state is layered on separately by
//  InboxStore (the SDK does not persist it).
//

import Foundation
import AEPMessaging

enum InboxMapper {

    static func map(_ items: [PropositionItem], surface: String) -> [InboxMessage] {
        items.compactMap { item in
            guard let content = PropositionParsing.contentDict(item) else { return nil }
            return InboxMessage(
                id: item.itemId,
                title: PropositionParsing.string(content, "title") ?? "Untitled",
                body: PropositionParsing.string(content, "body") ?? "",
                receivedAt: .now,          // AJO publish time not surfaced here; use fetch time
                isRead: false,             // InboxStore overrides this on load
                surface: surface
            )
        }
    }
}
