//
//  NimbusApp.swift
//  Nimbus
//
//  Created by Shubham Shinde on 22/07/26.
//

import SwiftUI

@main
struct NimbusApp: App {
    // Registers the AEP extensions at launch.
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    // Live, SDK-backed services (personalization via AEP Optimize).
    @State private var env = AppEnvironment.live()

    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(env)
                .task { await env.refreshIdentity() }
                // Keeps the in-app order card live on remote AJO pushes, not just
                // local advances. Long-lived subscription for the app's lifetime.
                .task { await env.observeLiveActivityUpdates() }
                // Assurance QR / deep link. Routes the registered `nimbus://`
                // scheme (CFBundleURLTypes in Info.plist) — set the Assurance
                // session's Base URL to `nimbus://` so scanning its QR opens the app.
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
