//
//  MockConsentService.swift
//  AEPSampleApp
//
//  Stage 0 impl: logs the requested consent state.
//

import Foundation

struct MockConsentService: ConsentService {
    func update(_ state: ConsentState) {
        // STAGE 1: Consent.update(with: ["consents": ["collect": ["val": ...]]])
        Log.sdk("consent update -> \(state.rawValue)")
    }
}
