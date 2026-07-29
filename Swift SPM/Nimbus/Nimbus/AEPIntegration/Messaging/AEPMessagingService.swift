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

    func currentPushStatus() async -> PushStatus {
        await PushManager.shared.currentStatus()
    }

    func requestPushAuthorization() async -> PushStatus {
        await PushManager.shared.request()
    }

    func sendTestPush() {
        // A real push is delivered by an AJO campaign, not the client. This
        // stays as a no-op with a log so the button remains a harmless demo cue.
        Log.debug(label: "Nimbus", "push delivery originates from an AJO campaign, not the app")
    }

    func fetchContentCards(surface: String) async -> [Proposition] {
        let items = await fetchItems(surface: surface)
        return ContentCardMapper.map(items)
    }

    func fetchInboxMessages(surface: String) async -> [InboxMessage] {
        let items = await fetchItems(surface: surface)
        return InboxMapper.map(items, surface: surface)
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
