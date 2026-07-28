//
//  SDKInboxView.swift
//  AEPSampleApp
//
//  Renders the AJO Inbox channel using the SDK's container UI
//  (Messaging.getInboxUI). The SDK draws the whole inbox — heading, capacity,
//  empty-state, unread indicators, dismiss — from the message/inbox container
//  plus its content cards. Lives in AEPIntegration; Features embed it.
//

import SwiftUI
import AEPMessaging

struct SDKInboxView: View {
    /// Relative surface path (e.g. "inbox"). The SDK prepends mobileapp://<bundle>/.
    let surfacePath: String

    @State private var listener = InboxLogger()
    @State private var inbox: InboxUI?
    private let customizer = CardCustomizer()

    var body: some View {
        Group {
            if let inbox {
                inbox.view
            } else {
                ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onAppear {
            guard inbox == nil else { return }
            inbox = Messaging.getInboxUI(for: Surface(path: surfacePath), customizer: customizer, listener: listener)
            Log.sdk("getInboxUI surface=\(surfacePath)")
        }
    }
}

/// Logs Inbox UI container + card events. Methods are `nonisolated` to match
/// the SDK's non-MainActor listener protocol.
final class InboxLogger: InboxEventListening {

    nonisolated func onLoading(_ inbox: InboxUI) { Log.sdk("inbox loading") }
    nonisolated func onSuccess(_ inbox: InboxUI) { Log.sdk("inbox loaded") }
    nonisolated func onError(_ inbox: InboxUI, _ error: Error) { Log.sdk("inbox error: \(error.localizedDescription)") }
    nonisolated func onCardCreated(_ card: ContentCardUI) {}
    nonisolated func onCardDisplayed(_ card: ContentCardUI) { Log.sdk("inbox card displayed: \(card.id)") }
    nonisolated func onCardDismissed(_ card: ContentCardUI) { Log.sdk("inbox card dismissed: \(card.id)") }

    nonisolated func onCardInteracted(_ card: ContentCardUI, _ interactionId: String, actionURL: URL?) -> Bool {
        Log.sdk("inbox card interact: \(interactionId) url=\(actionURL?.absoluteString ?? "-")")
        // Handle our own deep-link scheme in-app; otherwise let the SDK open it.
        guard let url = actionURL, url.scheme == DeepLinkRouter.scheme else { return false }
        Task { @MainActor in DeepLinkRouter.shared.handle(url) }
        return true
    }
}
