//
//  AEPDiagnosticsService.swift
//  AEPSampleApp
//
//  Real DiagnosticsService. Launches an Assurance session. Assurance has no
//  programmatic "end" — a session ends when disconnected from the web UI.
//

import Foundation
import AEPAssurance

struct AEPDiagnosticsService: DiagnosticsService {

    func startSession(url: URL) {
        Assurance.startSession(url: url)
        Log.sdk("Assurance.startSession \(url.absoluteString)")
    }

    func endSession() {
        // No public end API — the session ends from the Assurance web UI.
        Log.sdk("Assurance session ends from the web UI")
    }
}
