//
//  AEPEdgeConsentService.swift
//  Nimbus
//
//  Real ConsentService. Maps the app's ConsentState to the XDM consent payload
//  and calls Consent.update. `.pending` is never sent — the tag property's
//  default consent stands until the user actively chooses.
//

import AEPEdgeConsent
import AEPServices

struct AEPEdgeConsentService: ConsentService {
    func update(_ state: ConsentState) {
        guard state != .pending else { return }
        let value = state == .yes ? "y" : "n"
        let consents = ["consents": ["collect": ["val": value]]]
        Consent.update(with: consents)
        Log.debug(label: "Nimbus", "Consent.update collect=\(value)")
    }
}
