//
//  AEPEdgeIdentityService.swift
//  Nimbus
//
//  Real IdentityService. Reads the ECID from Edge Identity and links/unlinks an
//  email identity (standard "Email" namespace) so profiles are easy to target
//  in AJO audiences.
//

import AEPEdgeIdentity
import AEPServices

final class AEPEdgeIdentityService: IdentityService {

    // Standard AEP namespace — always available, trivial to segment on.
    private static let namespace = "Email"

    func experienceCloudId() async -> String? {
        await withCheckedContinuation { continuation in
            Identity.getExperienceCloudId { ecid, _ in
                continuation.resume(returning: ecid)
            }
        }
    }

    func loggedInEmail() async -> String? {
        await withCheckedContinuation { continuation in
            Identity.getIdentities { map, _ in
                let email = map?.getItems(withNamespace: Self.namespace)?
                    .first(where: { $0.authenticatedState == .authenticated })?.id
                continuation.resume(returning: email)
            }
        }
    }

    func login(username: String) {
        let map = IdentityMap()
        map.add(item: IdentityItem(id: username, authenticatedState: .authenticated, primary: true),
                withNamespace: Self.namespace)
        Identity.updateIdentities(with: map)
        Log.debug(label: "Nimbus", "updateIdentities — \(Self.namespace)=\(username)")
    }

    func logout() {
        // Remove every Email identity from the LOCAL identity map while keeping
        // the same ECID. We read the current identities first (robust across
        // relaunches) rather than remembering the last email in memory.
        // NOTE: this only unlinks on-device; the server identity graph already
        // stitched Email↔ECID and that link is permanent (same ECID keeps it).
        Identity.getIdentities { identityMap, _ in
            guard let items = identityMap?.getItems(withNamespace: Self.namespace) else { return }
            for item in items {
                Identity.removeIdentity(item: item, withNamespace: Self.namespace)
            }
            Log.debug(label: "Nimbus", "removeIdentity — cleared \(items.count) \(Self.namespace) identity(ies), ECID kept")
        }
    }
}
