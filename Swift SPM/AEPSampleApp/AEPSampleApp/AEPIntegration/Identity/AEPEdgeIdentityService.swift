//
//  AEPEdgeIdentityService.swift
//  AEPSampleApp
//
//  Real IdentityService. Reads the ECID from Edge Identity and links/unlinks a
//  local test-user id in a custom namespace to demonstrate identity linking.
//

import AEPEdgeIdentity

final class AEPEdgeIdentityService: IdentityService {

    private static let namespace = "testUserId"
    private var lastUsername: String?

    func experienceCloudId() async -> String? {
        await withCheckedContinuation { continuation in
            Identity.getExperienceCloudId { ecid, _ in
                continuation.resume(returning: ecid)
            }
        }
    }

    func login(username: String) {
        lastUsername = username
        let map = IdentityMap()
        map.add(item: IdentityItem(id: username, authenticatedState: .authenticated, primary: false),
                withNamespace: Self.namespace)
        Identity.updateIdentities(with: map)
        Log.sdk("updateIdentities — \(Self.namespace)=\(username)")
    }

    func logout() {
        if let username = lastUsername {
            Identity.removeIdentity(item: IdentityItem(id: username), withNamespace: Self.namespace)
            lastUsername = nil
            Log.sdk("removeIdentity — \(Self.namespace)")
        }
    }
}
