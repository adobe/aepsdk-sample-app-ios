//
//  AEPMessagingService.swift
//  Nimbus
//
//  Real MessagingService. Push (3a) via PushManager; content cards (3c) and
//  the inbox feed (3d) fetch real propositions per surface. Read/dismiss state
//  for the inbox is layered on locally by InboxStore in the view model.
//

import Foundation
import AEPMessaging
import AEPServices

struct AEPMessagingService: MessagingService {

    // Retains CBE PropositionItems + their parent Propositions so tracking works
    // after fetch (PropositionItem.proposition is a weak ref).
    private let cbe = CBEStore()
    // Retains content-card and inbox PropositionItems for carousel/custom tracking.
    private let cardItems = ItemStore()
    private let inboxItems = ItemStore()

    func currentPushStatus() async -> PushStatus {
        await PushManager.shared.currentStatus()
    }

    func requestPushAuthorization() async -> PushStatus {
        await PushManager.shared.request()
    }

    func fetchContentCards(surface: String) async -> [Proposition] {
        let items = await fetchItems(surface: surface)
        items.forEach { cardItems.itemsById[$0.itemId] = $0 }
        return ContentCardMapper.map(items)
    }

    func fetchInboxMessages(surface: String) async -> [InboxMessage] {
        let items = await fetchItems(surface: surface)
        items.forEach { inboxItems.itemsById[$0.itemId] = $0 }
        return InboxMapper.map(items, surface: surface)
    }

    func trackContentCardDisplay(_ itemId: String) {
        cardItems.itemsById[itemId]?.track(withEdgeEventType: .display)
    }

    func trackContentCardInteract(_ itemId: String) {
        cardItems.itemsById[itemId]?.track("click", withEdgeEventType: .interact)
    }

    func trackInboxInteract(_ itemId: String) {
        inboxItems.itemsById[itemId]?.track("read", withEdgeEventType: .interact)
    }

    func trackInboxDismiss(_ itemId: String) {
        inboxItems.itemsById[itemId]?.track(withEdgeEventType: .dismiss)
    }

    // MARK: Code-Based Experiences (CBE)

    func fetchCodeBasedExperiences(surface: String) async -> [Proposition] {
        let surfaceObj = Surface(path: surface)
        _ = await withCheckedContinuation { (continuation: CheckedContinuation<Bool, Never>) in
            Messaging.updatePropositionsForSurfaces([surfaceObj]) { continuation.resume(returning: $0) }
        }
        let propositions: [AEPMessaging.Proposition] = await withCheckedContinuation { continuation in
            Messaging.getPropositionsForSurfaces([surfaceObj]) { dict, _ in
                continuation.resume(returning: dict?[surfaceObj] ?? [])
            }
        }
        // Retain propositions so each item's weak `proposition` back-ref stays
        // valid for later display/interact tracking.
        cbe.propositions.append(contentsOf: propositions)

        var result: [Proposition] = []
        for proposition in propositions {
            for item in proposition.items where item.schema == .jsonContent {
                guard let json = item.jsonContentDictionary else { continue }
                cbe.itemsById[item.itemId] = item
                result.append(Self.mapCBE(id: item.itemId, json: json))
            }
        }
        Log.debug(label: "Nimbus", "CBE surface=\(surface) -> \(result.count) item(s)")
        return result
    }

    func trackCBEDisplay(_ itemId: String) {
        cbe.itemsById[itemId]?.track(withEdgeEventType: .display)
    }

    func trackCBEInteract(_ itemId: String) {
        cbe.itemsById[itemId]?.track("click", withEdgeEventType: .interact)
    }

    /// Maps a JSON CBE payload ({title, body, image}) to the app Proposition.
    private static func mapCBE(id: String, json: [String: Any]) -> Proposition {
        Proposition(
            id: id,
            title: json["title"] as? String ?? "Featured",
            body: json["body"] as? String ?? "",
            imageSystemName: json["image"] as? String ?? "sparkles"
        )
    }

    // MARK: Shared surface fetch

    /// Warm the surface, then read the cached items once the network response
    /// has been processed. The completion removes the need for a fixed delay.
    private func fetchItems(surface: String) async -> [PropositionItem] {
        // `surface` is the relative path (e.g. "home"); the SDK prepends
        // mobileapp://<bundleId>/ automatically.
        let surfaceObj = Surface(path: surface)

        _ = await withCheckedContinuation { (continuation: CheckedContinuation<Bool, Never>) in
            Messaging.updatePropositionsForSurfaces([surfaceObj]) { success in
                continuation.resume(returning: success)
            }
        }
        let propositions: [AEPMessaging.Proposition] = await withCheckedContinuation { continuation in
            Messaging.getPropositionsForSurfaces([surfaceObj]) { dict, _ in
                continuation.resume(returning: dict?[surfaceObj] ?? [])
            }
        }
        let items = propositions.flatMap { $0.items }
        Log.debug(label: "Nimbus", "propositions surface=\(surface) -> \(items.count) item(s)")
        return items
    }
}

/// Reference cache so the value-type service can retain CBE propositions/items
/// across calls — `PropositionItem.proposition` is weak and tracking needs it.
private final class CBEStore {
    var itemsById: [String: PropositionItem] = [:]
    var propositions: [AEPMessaging.Proposition] = []
}

/// Generic item cache for content-card and inbox tracking.
private final class ItemStore {
    var itemsById: [String: PropositionItem] = [:]
}
