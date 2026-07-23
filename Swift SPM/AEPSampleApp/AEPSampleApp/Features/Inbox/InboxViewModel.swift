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

    var unreadCount: Int { messages.filter { !$0.isRead }.count }

    func onAppear(_ env: AppEnvironment) async {
        guard !loaded else { return }
        loaded = true
        await refresh(env)
    }

    func refresh(_ env: AppEnvironment) async {
        isLoading = true
        messages = await env.messaging.fetchInboxMessages(surface: SurfaceURI.inbox)
        isLoading = false
    }

    func markRead(_ message: InboxMessage) {
        guard let idx = messages.firstIndex(where: { $0.id == message.id }) else { return }
        // STAGE 3d: persist read id via InboxStore + fire interact tracking.
        messages[idx].isRead = true
    }

    func dismiss(_ message: InboxMessage) {
        // STAGE 3d: persist dismissed id so it stays gone across relaunch.
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
