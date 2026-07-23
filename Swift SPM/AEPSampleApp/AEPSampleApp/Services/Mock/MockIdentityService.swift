//
//  MockIdentityService.swift
//  AEPSampleApp
//
//  Stage 0 impl: a stable fake ECID + logged login/logout.
//

import Foundation

final class MockIdentityService: IdentityService {
    // A stable mock ECID for the session so the status strip looks real.
    private let ecid = String(UInt64.random(in: 10_000_000_000_000_000...99_999_999_999_999_999))

    func experienceCloudId() async -> String? { ecid }

    func login(username: String) {
        // STAGE 1: Identity.updateIdentities(with: IdentityMap linking a custom
        // "testUserId" namespace to `username`).
        Log.sdk("login — link ECID \(ecid) <-> \(username)")
    }

    func logout() {
        // STAGE 1: Identity.removeIdentity(...) to unlink the authenticated id.
        Log.sdk("logout — unlink authenticated identity")
    }
}
