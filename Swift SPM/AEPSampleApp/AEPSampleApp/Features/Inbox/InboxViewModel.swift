//
//  InboxViewModel.swift
//  AEPSampleApp
//
//  Owns the inbox feed + Live Activity toggle. Read/dismiss state is held in
//  memory for Stage 0; Stage 3d moves it into a persistent InboxStore so it
//  survives relaunch (the SDK does not persist this itself).
//

import Observation

@Observable
final class InboxViewModel {

    private(set) var messages: [InboxMessage] = []
    private(set) var isLoading = false
    private(set) var liveActivityActive = false

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
        // Reconcile the fetched feed with locally-persisted read/dismiss state.
        messages = fetched
            .filter { !store.isDismissed($0.id) }
            .map { message in
                var m = message
                m.isRead = store.isRead(message.id)
                return m
            }
        isLoading = false
    }

    func markRead(_ message: InboxMessage) {
        guard let idx = messages.firstIndex(where: { $0.id == message.id }) else { return }
        store.markRead(message.id)      // persists across relaunch
        messages[idx].isRead = true
    }

    func dismiss(_ message: InboxMessage) {
        store.dismiss(message.id)       // stays gone across relaunch
        messages.removeAll { $0.id == message.id }
    }

    func toggleLiveActivity(_ env: AppEnvironment) async {
        if liveActivityActive {
            await env.liveActivity.endOrderTracking()
            liveActivityActive = false
        } else {
            liveActivityActive = await env.liveActivity.startOrderTracking()
        }
    }
}
