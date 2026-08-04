//
//  DiagnosticsService.swift
//  Nimbus
//
//  Seam for Assurance. Connecting a session is fire-and-forget: the Assurance
//  SDK presents its own PIN overlay and streams the full event hub to its web
//  UI. The in-app SDK Event Log (EventLog) is a separate, local companion.
//

import Foundation

protocol DiagnosticsService {
    /// Launches an Assurance session from a session URL (QR / deep link /
    /// pasted link). The SDK then shows its PIN overlay.
    func startSession(url: URL)
}
