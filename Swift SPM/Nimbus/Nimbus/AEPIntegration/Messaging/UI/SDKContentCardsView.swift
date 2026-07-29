//
//  SDKContentCardsView.swift
//  Nimbus
//
//  Renders AJO content cards using the SDK's TEMPLATED UI
//  (Messaging.getContentCardsUI) — the counterpart to the app's custom
//  raw-proposition rendering. Lives in AEPIntegration because it imports the
//  SDK; Features embed it as an opaque view.
//
//  Display / interaction / dismiss are tracked automatically by the SDK; the
//  attached listener just mirrors those events into the SDK Event Log console.
//

import SwiftUI
import AEPMessaging
import AEPServices

struct SDKContentCardsView: View {
    /// Relative surface path (e.g. "test_cc"). The SDK prepends mobileapp://<bundle>/.
    let surfacePath: String

    @State private var cards: [ContentCardUI] = []
    @State private var isLoading = true
    @State private var listener = ContentCardLogger()
    private let customizer = CardCustomizer()

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if isLoading {
                ProgressView().frame(maxWidth: .infinity).padding(.vertical, 12)
            } else if cards.isEmpty {
                Text("No SDK content cards for this surface.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(cards) { card in
                    card.view
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .task { await load() }
    }

    private func load() async {
        let surface = Surface(path: surfacePath)

        // getContentCardsUI only READS the cache, so warm it first. The
        // completion fires once the network response has been processed — no
        // polling needed. Only read the templated UI if the warm succeeded, so
        // we never call getContentCardsUI on an empty cache (which logs errors).
        let updated: Bool = await withCheckedContinuation { continuation in
            Messaging.updatePropositionsForSurfaces([surface]) { success in
                continuation.resume(returning: success)
            }
        }
        cards = updated ? await fetchUI(for: surface) : []
        isLoading = false
        Log.debug(label: "Nimbus", "getContentCardsUI surface=\(surfacePath) -> \(cards.count) card(s)")
    }

    private func fetchUI(for surface: Surface) async -> [ContentCardUI] {
        await withCheckedContinuation { continuation in
            Messaging.getContentCardsUI(for: surface, customizer: customizer, listener: listener) { result in
                switch result {
                case .success(let cards): continuation.resume(returning: cards)
                case .failure:            continuation.resume(returning: [])
                }
            }
        }
    }
}

/// Logs content-card UI events. Methods are `nonisolated` to match the SDK's
/// non-MainActor listener protocol.
final class ContentCardLogger: ContentCardUIEventListening {

    nonisolated func onDisplay(_ card: ContentCardUI) {
        Log.debug(label: "Nimbus", "content card displayed: \(card.id)")
    }

    nonisolated func onDismiss(_ card: ContentCardUI) {
        Log.debug(label: "Nimbus", "content card dismissed: \(card.id)")
    }

    nonisolated func onInteract(_ card: ContentCardUI, _ interactionId: String, actionURL: URL?) -> Bool {
        Log.debug(label: "Nimbus", "content card interact: \(interactionId) url=\(actionURL?.absoluteString ?? "-")")
        // Custom-action scenario: handle our own scheme in-app (e.g. the Welcome
        // card's CTA → switch tab); otherwise let the SDK open the URL.
        guard let url = actionURL, url.scheme == DeepLinkRouter.scheme else { return false }
        Task { @MainActor in DeepLinkRouter.shared.handle(url) }
        return true
    }
}
