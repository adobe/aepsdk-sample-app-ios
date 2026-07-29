//
//  PropositionParsing.swift
//  Nimbus
//
//  Shared helpers for pulling fields out of AEPMessaging proposition items.
//  Used by ContentCardMapper (Home) and InboxMapper (Inbox) so the JSON-shape
//  knowledge lives in one place.
//

import AEPMessaging

enum PropositionParsing {

    /// The content-card template payload as a dictionary, if present.
    static func contentDict(_ item: PropositionItem) -> [String: Any]? {
        item.contentCardSchemaData?.content as? [String: Any]
    }

    /// Content-card fields are shaped like `{ "title": { "content": "…" } }`.
    static func string(_ dict: [String: Any], _ key: String) -> String? {
        (dict[key] as? [String: Any])?["content"] as? String
    }
}
