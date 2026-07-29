//
//  AEPBootstrapper.swift
//  Nimbus
//
//  The single place that registers AEP extensions and configures the SDK.
//  App-layer code (AppDelegate / App scene) calls these wrappers so it never
//  imports an Adobe module directly.
//
//  Registers all AEP extensions the app uses: Edge, Edge Identity, Edge
//  Consent, Lifecycle, Signal, Assurance, Messaging.
//

import AEPCore
import AEPEdge
import AEPEdgeIdentity
import AEPEdgeConsent
import AEPLifecycle
import AEPSignal
import AEPAssurance
import AEPMessaging

enum AEPBootstrapper {

    static func start() {
        MobileCore.setLogLevel(AEPConfig.logLevel)
        // Capture the real SDK event stream into the in-app EventLog.
        SDKEventRecorder.start()
        /// try with MobileCore.initialize
        MobileCore.registerExtensions([
            Edge.self,
            Identity.self,        // AEPEdgeIdentity (classic AEPIdentity is not imported)
            Consent.self,
            Lifecycle.self,
            Signal.self,
            Assurance.self,
            Messaging.self
        ]) {
            MobileCore.configureWith(appId: AEPConfig.appId)
        }
        // Controls AJO in-app message presentation (gating, lifecycle, deep links).
        MobileCore.messagingDelegate = InAppMessageDelegate.shared

        // Register Live Activity type so the SDK collects push-to-start / update
        // tokens and can drive the activity from AJO.
        Messaging.registerLiveActivities([OrderActivityAttributes.self])
    }

    static func lifecycleStart() {
        MobileCore.lifecycleStart(additionalContextData: nil)
    }

    static func lifecyclePause() {
        MobileCore.lifecyclePause()
    }
}
