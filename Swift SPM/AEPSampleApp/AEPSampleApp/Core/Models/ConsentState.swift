//
//  ConsentState.swift
//  AEPSampleApp
//
//  App-owned consent model. Intentionally NOT an SDK type — the AEP
//  Edge Consent payload is mapped to/from this at the integration boundary
//  (Stage 1) so the UI never imports an Adobe module.
//

import Foundation

enum ConsentState: String, CaseIterable {
    case pending
    case yes
    case no

    var label: String {
        switch self {
        case .pending: return "pending"
        case .yes: return "granted"
        case .no: return "declined"
        }
    }
}
