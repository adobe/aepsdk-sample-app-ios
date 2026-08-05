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

    /// Reads the Identity Map for a persisted authenticated Email item.
    /// Returns the email string if the user was previously logged in, nil otherwise.
    func loggedInEmail() async -> String?

    func login(username: String)
    func logout()
}
