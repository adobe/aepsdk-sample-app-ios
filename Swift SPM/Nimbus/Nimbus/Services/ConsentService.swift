//
//  ConsentService.swift
//  Nimbus
//
//  Seam for Edge Consent. The impl maps the state to an XDM consent payload and
//  calls Consent.update(...). Shared consent state lives on AppEnvironment so
//  every screen observes changes.
//

protocol ConsentService {
    func update(_ state: ConsentState)
}
