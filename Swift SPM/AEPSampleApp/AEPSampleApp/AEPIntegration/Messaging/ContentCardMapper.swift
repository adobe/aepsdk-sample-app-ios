//
//  ContentCardMapper.swift
//  AEPSampleApp
//
//  Maps AEPMessaging proposition items (content cards / code-based experiences)
//  into the app's own Proposition model, so the UI never touches SDK types.
//  This is the integration boundary the architecture depends on.
//

import Foundation
import AEPMessaging

enum ContentCardMapper {

    /// Convert SDK proposition items for a surface into app Propositions.
    static func map(_ items: [PropositionItem], surface: String) -> [Proposition] {
        items.compactMap { item in
            // Content-card template content is a JSON dictionary.
            guard let content = item.contentCardSchemaData?.content as? [String: Any] else {
                return nil
            }
            let title = string(content, "title") ?? "Untitled"
            let body  = string(content, "body") ?? ""
            return Proposition(
                id: item.itemId,
                scope: surface,
                title: title,
                body: body,
                imageSystemName: "megaphone.fill",   // AJO cards carry image URLs, not SF Symbols
                rawJSON: prettyJSON(content)
            )
        }
    }

    // Content-card fields are shaped like `{ "title": { "content": "…" } }`.
    private static func string(_ dict: [String: Any], _ key: String) -> String? {
        (dict[key] as? [String: Any])?["content"] as? String
    }

    private static func prettyJSON(_ dict: [String: Any]) -> String {
        guard
            let data = try? JSONSerialization.data(withJSONObject: dict, options: [.prettyPrinted, .sortedKeys]),
            let string = String(data: data, encoding: .utf8)
        else { return "\(dict)" }
        return string
    }
}
