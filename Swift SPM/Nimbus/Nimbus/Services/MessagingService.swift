//
//  MessagingService.swift
//  Nimbus
//
//  Seam for the AJO Messaging suite (push, content cards, inbox feed). In-app
//  messages and Live Activities have their own seams. Backed by the real
//  AEPMessaging APIs.
//

import Foundation

enum PushStatus {
    case notRequested
    case granted
    case denied

    var label: String {
        switch self {
        case .notRequested: return "Not requested"
        case .granted:      return "Granted"
        case .denied:       return "Denied"
        }
    }
}

protocol MessagingService {
    func currentPushStatus() async -> PushStatus

    /// Prompts for notification authorization + registers the push token.
    func requestPushAuthorization() async -> PushStatus

    /// Content cards / code-based experiences for a surface (e.g. home).
    func fetchContentCards(surface: String) async -> [Proposition]

    /// Inbox/feed messages for the inbox surface.
    func fetchInboxMessages(surface: String) async -> [InboxMessage]

    /// Code-Based Experiences (JSON schema) for a surface, mapped to app
    /// Propositions for custom rendering — distinct from content cards
    /// (which use the SDK's templated `getContentCardsUI`).
    func fetchCodeBasedExperiences(surface: String) async -> [Proposition]

    /// CBE interaction tracking, keyed by PropositionItem id.
    func trackCBEDisplay(_ itemId: String)
    func trackCBEInteract(_ itemId: String)

    /// Custom content-card carousel tracking, keyed by PropositionItem id.
    func trackContentCardDisplay(_ itemId: String)
    func trackContentCardInteract(_ itemId: String)

    /// Custom inbox tracking, keyed by PropositionItem id.
    func trackInboxInteract(_ itemId: String)
    func trackInboxDismiss(_ itemId: String)
}
