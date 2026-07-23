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

    // TODO Stage 3c/3d: replace with real updatePropositionsForSurfaces.
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
        await contentFallback.fetchContentCards(surface: surface)
    }

    func fetchInboxMessages(surface: String) async -> [InboxMessage] {
        await contentFallback.fetchInboxMessages(surface: surface)
    }
}
