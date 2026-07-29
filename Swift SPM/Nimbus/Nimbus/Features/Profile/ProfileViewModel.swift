//
//  ProfileViewModel.swift
//  Nimbus
//
//  Owns push-permission state for the Profile screen. Identity and consent
//  mutations go straight through AppEnvironment (shared state), so this model
//  only tracks the notification status.
//

import Observation

@Observable
final class ProfileViewModel {
    private(set) var pushStatus: PushStatus = .notRequested
    private var loaded = false

    func onAppear(_ env: AppEnvironment) async {
        guard !loaded else { return }
        loaded = true
        pushStatus = await env.messaging.currentPushStatus()
    }

    func requestPush(_ env: AppEnvironment) async {
        pushStatus = await env.messaging.requestPushAuthorization()
    }

    func sendTestPush(_ env: AppEnvironment) {
        env.messaging.sendTestPush()
    }
}
