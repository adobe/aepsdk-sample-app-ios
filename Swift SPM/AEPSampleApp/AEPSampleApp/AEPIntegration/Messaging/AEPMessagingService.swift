//
//  AEPMessagingService.swift
//  AEPSampleApp
//
//  Real MessagingService. Stage 3a wires push (authorization + token) to the
//  live SDK via PushManager. Content cards (3c) and inbox feed (3d) still come
//  from the mock fallback until those stages land — so Home/Inbox stay
//  populated in the meantime.
//

import Foundation
import AEPMessaging

struct AEPMessagingService: MessagingService {

    // TODO Stage 3d: replace inbox with real surface fetch.
    private let contentFallback = MockMessagingService()

    func currentPushStatus() async -> PushStatus {
        await PushManager.shared.currentStatus()
    }

    func requestPushAuthorization() async -> PushStatus {
        await PushManager.shared.request()
    }

    func sendTestPush() {
        // A real push is delivered by an AJO campaign, not the client. This
        // stays as a no-op with a log so the button remains a harmless demo cue.
        Log.sdk("push delivery originates from an AJO campaign, not the app")
    }

    func refreshInAppMessages() {
        Messaging.refreshInAppMessages()
        Log.sdk("Messaging.refreshInAppMessages")
    }

    func fetchContentCards(surface: String) async -> [Proposition] {
        let path = SurfaceURI.path(from: surface)
        let surfaceObj = Surface(path: path)

        // updatePropositions fetches async with no completion; give it a moment
        // to populate the cache, then read it back.
        Messaging.updatePropositionsForSurfaces([surfaceObj])
        try? await Task.sleep(for: .seconds(1))
        let propositions: [AEPMessaging.Proposition] = await withCheckedContinuation { continuation in
            Messaging.getPropositionsForSurfaces([surfaceObj]) { dict, _ in
                continuation.resume(returning: dict?[surfaceObj] ?? [])
            }
        }
        let items = propositions.flatMap { $0.items }
        Log.sdk("content cards surface=\(path) -> \(items.count) item(s)")
        return ContentCardMapper.map(items, surface: surface)
    }

    func fetchInboxMessages(surface: String) async -> [InboxMessage] {
        await contentFallback.fetchInboxMessages(surface: surface)
    }
}
