//
//  InboxViewModel.swift
//  Nimbus
//
//  Owns the inbox feed only. Live Activity state lives on AppEnvironment so
//  both CartView (starts it) and InboxView (controls it) share the same truth.
//

import Observation

@Observable
final class InboxViewModel {

    private(set) var messages: [InboxMessage] = []
    private(set) var isLoading = false

    private var loaded = false
    private let store = InboxStore()

    var unreadCount: Int { messages.filter { !$0.isRead }.count }

    func onAppear(_ env: AppEnvironment) async {
        guard !loaded else { return }
        loaded = true
        await refresh(env)
    }

    func refresh(_ env: AppEnvironment) async {
        isLoading = true
        let fetched = await env.messaging.fetchInboxMessages(surface: SurfaceURI.inbox)
        messages = fetched
            .filter { !store.isDismissed($0.id) }
            .map { message in
                var m = message
                m.isRead = store.isRead(message.id)
                return m
            }
        isLoading = false
    }

    func markRead(_ message: InboxMessage, env: AppEnvironment) {
        guard let idx = messages.firstIndex(where: { $0.id == message.id }) else { return }
        store.markRead(message.id)
        messages[idx].isRead = true
        env.messaging.trackInboxInteract(message.id)
    }

    func dismiss(_ message: InboxMessage, env: AppEnvironment) {
        store.dismiss(message.id)
        messages.removeAll { $0.id == message.id }
        env.messaging.trackInboxDismiss(message.id)
    }
}
