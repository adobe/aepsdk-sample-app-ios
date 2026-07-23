//
//  DiagnosticsService.swift
//  AEPSampleApp
//
//  Seam for Assurance. Connecting a session is fire-and-forget: the Assurance
//  SDK presents its own PIN overlay and streams the full event hub to its web
//  UI. The in-app event log (EventLog) is a separate, local companion.
//

import Foundation

struct ExtensionInfo: Identifiable {
    var id: String { name }
    let name: String
    let version: String
}

protocol DiagnosticsService {
    /// Registered extensions + versions shown in the Dev Console.
    var registeredExtensions: [ExtensionInfo] { get }

    /// Launches an Assurance session from a session URL (QR / deep link /
    /// pasted link). The SDK then shows its PIN overlay.
    func startSession(url: URL)

    func endSession()
}
