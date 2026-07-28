//
//  AEPBootstrapper.swift
//  AEPSampleApp
//
//  The single place that registers AEP extensions and configures the SDK.
//  App-layer code (AppDelegate / App scene) calls these wrappers so it never
//  imports an Adobe module directly.
//
//  Stage 1 registers the foundation: Edge, Edge Identity, Edge Consent,
//  Lifecycle, Signal. Messaging (Stage 3), Optimize (Stage 4) and Assurance
//  (Stage 2) are added to this list as those stages land.
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
