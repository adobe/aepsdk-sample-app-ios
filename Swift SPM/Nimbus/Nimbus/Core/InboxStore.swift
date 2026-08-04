//
//  InboxStore.swift
//  Nimbus
//
//  Local persistence of inbox read/dismissed message ids. The Messaging SDK
//  caches propositions in-memory per session but does NOT persist read/dismiss
//  state across launches — so the app owns it here (UserDefaults).
//

import Foundation

final class InboxStore {
    private let defaults: UserDefaults
    private let readKey = "inbox.read.ids"
    private let dismissedKey = "inbox.dismissed.ids"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    // MARK: Reads

    func isRead(_ id: String) -> Bool { readIds.contains(id) }
    func isDismissed(_ id: String) -> Bool { dismissedIds.contains(id) }

    // MARK: Writes

    func markRead(_ id: String) {
        var ids = readIds
        ids.insert(id)
        defaults.set(Array(ids), forKey: readKey)
    }

    func dismiss(_ id: String) {
        var ids = dismissedIds
        ids.insert(id)
        defaults.set(Array(ids), forKey: dismissedKey)
    }

    // MARK: Backing sets

    private var readIds: Set<String> {
        Set(defaults.stringArray(forKey: readKey) ?? [])
    }

    private var dismissedIds: Set<String> {
        Set(defaults.stringArray(forKey: dismissedKey) ?? [])
    }
}
