//
//  ContentCardMapper.swift
//  AEPSampleApp
//
//  Maps AEPMessaging proposition items (content cards) into the app's own
//  Proposition model, so the UI never touches SDK types. This is the
//  integration boundary the architecture depends on.
//

import Foundation
import AEPMessaging

enum ContentCardMapper {

    /// Convert SDK proposition items for a surface into app Propositions.
    static func map(_ items: [PropositionItem], surface: String) -> [Proposition] {
        items.compactMap { item in
            guard let content = PropositionParsing.contentDict(item) else { return nil }
            return Proposition(
                id: item.itemId,
                scope: surface,
                title: PropositionParsing.string(content, "title") ?? "Untitled",
                body: PropositionParsing.string(content, "body") ?? "",
                imageSystemName: "megaphone.fill",   // AJO cards carry image URLs, not SF Symbols
                rawJSON: PropositionParsing.prettyJSON(content)
            )
        }
    }
}
