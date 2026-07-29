//
//  SDKContentCardsView.swift
//  AEPSampleApp
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

        // getContentCardsUI only READS the cache and returns .failure (logging an
        // error) when the surface isn't cached yet. So warm the cache, then poll
        // the RAW propositions (which return empty cleanly, no error) until ready,
        // and only THEN call getContentCardsUI once — so it never fails.
        
        
         Messaging.updatePropositionsForSurfaces([surface])
        for _ in 1...8 {
            try? await Task.sleep(for: .milliseconds(400))
            guard await hasPropositions(for: surface) else { continue }
            cards = await fetchUI(for: surface)
            isLoading = false
            Log.sdk("getContentCardsUI surface=\(surfacePath) -> \(cards.count) card(s)")
            return
        }
        cards = []
        isLoading = false
        Log.sdk("getContentCardsUI surface=\(surfacePath) -> 0 card(s) (no propositions)")
    }

    /// Clean readiness check — getPropositionsForSurfaces returns empty (not an
    /// error) when the surface isn't cached yet.
    private func hasPropositions(for surface: Surface) async -> Bool {
        await withCheckedContinuation { continuation in
            Messaging.getPropositionsForSurfaces([surface]) { dict, _ in
                continuation.resume(returning: !(dict?[surface]?.isEmpty ?? true))
            }
        }
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
        Log.sdk("content card displayed: \(card.id)")
    }

    nonisolated func onDismiss(_ card: ContentCardUI) {
        Log.sdk("content card dismissed: \(card.id)")
    }

    nonisolated func onInteract(_ card: ContentCardUI, _ interactionId: String, actionURL: URL?) -> Bool {
        Log.sdk("content card interact: \(interactionId) url=\(actionURL?.absoluteString ?? "-")")
        // Custom-action scenario: handle our own scheme in-app (e.g. the Welcome
        // card's CTA → switch tab); otherwise let the SDK open the URL.
        guard let url = actionURL, url.scheme == DeepLinkRouter.scheme else { return false }
        Task { @MainActor in DeepLinkRouter.shared.handle(url) }
        return true
    }
}
