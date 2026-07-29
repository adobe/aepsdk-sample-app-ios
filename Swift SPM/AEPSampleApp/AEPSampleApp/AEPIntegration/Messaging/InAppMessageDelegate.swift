//
//  InAppMessageDelegate.swift
//  AEPSampleApp
//
//  Controls AJO in-app message presentation. Set as MobileCore.messagingDelegate
//  in the bootstrapper. Display/interaction tracking is automatic; this hook is
//  for gating (shouldShowMessage), lifecycle logging, and custom-action /
//  deep-link handling from message buttons.
//
//  Methods are `nonisolated` to match the SDK's non-MainActor protocol.
//

import Foundation
import AEPServices

final class InAppMessageDelegate: NSObject, MessagingDelegate {

    static let shared = InAppMessageDelegate()
    private override init() {}

    nonisolated func onShow(message: Showable) {
        Log.sdk("in-app message shown")
    }

    nonisolated func onDismiss(message: Showable) {
        Log.sdk("in-app message dismissed")
    }

    nonisolated func shouldShowMessage(message: Showable) -> Bool {
        // Gate for suppressing a message before it displays; always show here.
        true
    }

    nonisolated func urlLoaded(_ url: URL, byMessage message: Showable) {
        // Custom actions / deep links from message buttons arrive here.
        Log.sdk("in-app message url loaded: \(url.absoluteString)")
    }
}
