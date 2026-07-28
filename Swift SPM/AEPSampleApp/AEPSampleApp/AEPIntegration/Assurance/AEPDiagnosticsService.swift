//
//  AEPDiagnosticsService.swift
//  AEPSampleApp
//
//  Real DiagnosticsService. Launches an Assurance session (the session ends
//  from the Assurance web UI — there is no client-side end API).
//

import Foundation
import AEPAssurance

struct AEPDiagnosticsService: DiagnosticsService {

    func startSession(url: URL) {
        Assurance.startSession(url: url)
        Log.sdk("Assurance.startSession \(url.absoluteString)")
    }
}
