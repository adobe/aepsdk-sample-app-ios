//
//  ConsentService.swift
//  AEPSampleApp
//
//  Seam for Edge Consent. The mock logs the requested state; Stage 1 maps it
//  to the XDM consent payload and calls Consent.update(...). Shared consent
//  state lives on AppEnvironment so every screen observes changes.
//

import Foundation

protocol ConsentService {
    func update(_ state: ConsentState)
}
