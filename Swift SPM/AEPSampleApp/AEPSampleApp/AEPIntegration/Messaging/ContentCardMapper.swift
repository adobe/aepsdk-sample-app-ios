//
//  ContentCardMapper.swift
//  AEPSampleApp
//
//  Maps AEPMessaging proposition items (content cards) into the app's own
//  Proposition model, so the UI never touches SDK types. This is the
//  integration boundary the architecture depends on.
//

import AEPMessaging

enum ContentCardMapper {

    static func map(_ items: [PropositionItem]) -> [Proposition] {
        items.compactMap { item in
            guard let content = PropositionParsing.contentDict(item) else { return nil }
            return Proposition(
                id: item.itemId,
                title: PropositionParsing.string(content, "title") ?? "Untitled",
                body: PropositionParsing.string(content, "body") ?? "",
                imageSystemName: "megaphone.fill"   // AJO cards carry image URLs, not SF Symbols
            )
        }
    }
}
