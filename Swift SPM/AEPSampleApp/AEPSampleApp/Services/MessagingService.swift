//
//  MessagingService.swift
//  AEPSampleApp
//
//  Seam for the AJO Messaging suite (push, content cards, inbox feed). In-app
//  messages and Live Activities have their own seams. The mock returns canned
//  data; Stage 3 wires the real AEPMessaging APIs behind the same signatures.
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

    /// Dev-only convenience to fire a test push at this device.
    func sendTestPush()

    /// Content cards / code-based experiences for a surface (e.g. home).
    func fetchContentCards(surface: String) async -> [Proposition]

    /// Inbox/feed messages for the inbox surface.
    func fetchInboxMessages(surface: String) async -> [InboxMessage]
}
