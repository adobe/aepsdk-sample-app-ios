//
//  MockMessagingService.swift
//  AEPSampleApp
//
//  Stage 0 impl: canned content cards + inbox feed, fake push status.
//

import Foundation

final class MockMessagingService: MessagingService {
    private var pushStatus: PushStatus = .notRequested

    func currentPushStatus() async -> PushStatus { pushStatus }

    func requestPushAuthorization() async -> PushStatus {
        // STAGE 3a: UNUserNotificationCenter.requestAuthorization + register for
        // remote notifications, then MobileCore.setPushIdentifier(deviceToken).
        try? await Task.sleep(for: .milliseconds(400))
        pushStatus = .granted
        Log.sdk("push authorization -> granted (mock)")
        return pushStatus
    }

    func sendTestPush() {
        // STAGE 3a: dev-only trigger; a real push is sent from AJO to this device.
        Log.sdk("sendTestPush (mock — no real notification)")
    }

    func fetchContentCards(surface: String) async -> [Proposition] {
        // STAGE 3c: Messaging.updatePropositionsForSurfaces([Surface(path:)]) +
        // getContentCardsUI, mapping ContentCardUI -> Proposition.
        try? await Task.sleep(for: .milliseconds(500))
        Log.sdk("fetchContentCards surface=\(surface)")
        return [
            Proposition(id: "cc-1", scope: surface, title: "New arrivals",
                        body: "Fresh drops this week", imageSystemName: "shippingbox.fill",
                        rawJSON: #"{ "surface": "\#(surface)", "id": "cc-1" }"#),
            Proposition(id: "cc-2", scope: surface, title: "Free shipping",
                        body: "On orders over $30", imageSystemName: "truck.box.fill",
                        rawJSON: #"{ "surface": "\#(surface)", "id": "cc-2" }"#),
        ]
    }

    func fetchInboxMessages(surface: String) async -> [InboxMessage] {
        // STAGE 3d: fetch the inbox feed surface; read/dismiss state is layered
        // on locally by InboxStore.
        try? await Task.sleep(for: .milliseconds(500))
        Log.sdk("fetchInboxMessages surface=\(surface)")
        let now = Date()
        return [
            InboxMessage(id: "in-1", title: "New drop just landed",
                         body: "Check out this week's featured picks.",
                         receivedAt: now.addingTimeInterval(-120), isRead: false,
                         surface: surface, rawJSON: #"{ "id": "in-1" }"#),
            InboxMessage(id: "in-2", title: "Your order shipped",
                         body: "Track it right from the app.",
                         receivedAt: now.addingTimeInterval(-3600), isRead: true,
                         surface: surface, rawJSON: #"{ "id": "in-2" }"#),
            InboxMessage(id: "in-3", title: "Welcome to AEP Sample",
                         body: "Thanks for trying the app.",
                         receivedAt: now.addingTimeInterval(-86400), isRead: true,
                         surface: surface, rawJSON: #"{ "id": "in-3" }"#),
        ]
    }
}
