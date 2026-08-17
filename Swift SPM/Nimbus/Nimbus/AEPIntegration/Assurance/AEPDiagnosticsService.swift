//
//  AEPDiagnosticsService.swift
//  Nimbus
//
//  Real DiagnosticsService. Launches an Assurance session (the session ends
//  from the Assurance web UI — there is no client-side end API).
//

import Foundation
import AEPAssurance
import AEPServices

struct AEPDiagnosticsService: DiagnosticsService {

    func startSession(url: URL) {
        Assurance.startSession(url: url)
        Log.debug(label: "Nimbus", "Assurance.startSession \(url.absoluteString)")
    }
}
