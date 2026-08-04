//
//  IdentityService.swift
//  Nimbus
//
//  Seam for Edge Identity. `ecid` is read once at startup to seed the shared
//  app state. login/logout demonstrate identity linking (anonymous ECID <->
//  authenticated test-user namespace) via a local mock login — no real auth.
//

import Foundation

protocol IdentityService {
    /// Anonymous device identifier. Async because the real Edge Identity API
    /// returns the ECID via callback, not synchronously at init.
    func experienceCloudId() async -> String?

    func login(username: String)
    func logout()
}
