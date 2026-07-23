//
//  AEPDiagnosticsService.swift
//  AEPSampleApp
//
//  Real DiagnosticsService. Launches an Assurance session and reports the live
//  extension versions. Assurance has no programmatic "end" — a session ends
//  when disconnected from the web UI.
//

import Foundation
import AEPCore
import AEPEdge
import AEPEdgeIdentity
import AEPEdgeConsent
import AEPLifecycle
import AEPSignal
import AEPAssurance

struct AEPDiagnosticsService: DiagnosticsService {

    var registeredExtensions: [ExtensionInfo] {
        [
            ExtensionInfo(name: "Mobile Core",  version: MobileCore.extensionVersion),
            ExtensionInfo(name: "Edge",         version: Edge.extensionVersion),
            ExtensionInfo(name: "Edge Identity", version: Identity.extensionVersion),
            ExtensionInfo(name: "Edge Consent", version: Consent.extensionVersion),
            ExtensionInfo(name: "Lifecycle",    version: Lifecycle.extensionVersion),
            ExtensionInfo(name: "Signal",       version: Signal.extensionVersion),
            ExtensionInfo(name: "Assurance",    version: Assurance.extensionVersion)
        ]
    }

    func startSession(url: URL) {
        Assurance.startSession(url: url)
        Log.sdk("Assurance.startSession \(url.absoluteString)")
    }

    func endSession() {
        // No public end API — the session ends from the Assurance web UI.
        Log.sdk("Assurance session ends from the web UI")
    }
}
