/*
 Copyright 2020 Adobe
 All Rights Reserved.
 
 NOTICE: Adobe permits you to use, modify, and distribute this file in
 accordance with the terms of the Adobe license agreement accompanying
 it.
 */

import UIKit
// step-init-start
import AEPCore
import AEPIdentity
import AEPLifecycle
import AEPSignal
// step-init-end
import AVKit
import AdSupport
// step-assurance-start
import AEPAssurance
// step-assurance-end

//step-extension-start
import AEPSampleExtensionSwift
//step-extension-end

//step-edge-start
import AEPEdge
import AEPEdgeConsent
import AEPEdgeIdentity
import AEPTarget
//step-edge-end

import AEPUserProfile

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    private let LAUNCH_ENVIRONMENT_FILE_ID = ""

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // step-init-start
        MobileCore.setLogLevel(.trace)
        let appState = application.applicationState;
        
        let extensions = [AEPIdentity.Identity.self,
                          Lifecycle.self,
                          Signal.self,
                          Edge.self,
                          Consent.self,
                          Target.self,
                          AEPEdgeIdentity.Identity.self
                          //step-extension-start
                          , SampleExtension.self
                          //step-extension-end
                          , UserProfile.self
                          // step-assurance-start
                          , AEPAssurance.self
                          // step-assurance-end
                        ]
        
        MobileCore.registerExtensions(extensions, {
            // Use the App id assigned to this application via Adobe Launch
            MobileCore.configureWith(appId: self.LAUNCH_ENVIRONMENT_FILE_ID)
            if appState != .background {
                // only start lifecycle if the application is not in the background
                MobileCore.lifecycleStart(additionalContextData: ["contextDataKey": "contextDataVal"])
            }

        })
        // step-init-end
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

