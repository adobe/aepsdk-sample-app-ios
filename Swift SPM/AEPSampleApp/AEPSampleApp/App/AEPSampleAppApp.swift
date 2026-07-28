//
//  AEPSampleAppApp.swift
//  AEPSampleApp
//
//  Created by Shubham Shinde on 22/07/26.
//

import SwiftUI

@main
struct AEPSampleAppApp: App {
    // Registers the AEP extensions at launch.
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    // Live, SDK-backed services (personalization is still a stand-in).
    @State private var env = AppEnvironment.live()

    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(env)
                .task { await env.refreshIdentity() }
                // Assurance QR / deep link (assurance://... or your app scheme).
                .onOpenURL { url in env.diagnostics.startSession(url: url) }
        }
        .onChange(of: scenePhase) { _, phase in
            switch phase {
            case .active:     AEPBootstrapper.lifecycleStart()
            case .background: AEPBootstrapper.lifecyclePause()
            default:          break
            }
        }
    }
}
