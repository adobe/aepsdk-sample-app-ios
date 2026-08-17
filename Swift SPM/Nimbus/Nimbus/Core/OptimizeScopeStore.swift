//
//  OptimizeScopeStore.swift
//  Nimbus
//
//  Shared local store for the Optimize decision scopes entered in the Profile
//  lab (OptimizeOffersView). Persisted in UserDefaults — the lab writes via
//  @AppStorage on these keys, and Home reads them back so both screens share
//  one configuration.
//

import Foundation

enum OptimizeScopeStore {
    static let ajoKey = "optimize.ajoScope"
    static let targetKey = "optimize.targetActivity"

    /// AJO Offer Decisioning encoded scope (trimmed; "" if unset).
    static var ajoScope: String {
        (UserDefaults.standard.string(forKey: ajoKey) ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Adobe Target activity/mbox name (trimmed; "" if unset).
    static var targetActivity: String {
        (UserDefaults.standard.string(forKey: targetKey) ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
