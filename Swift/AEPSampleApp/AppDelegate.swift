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
//step-edge-end

//step-messaging-start
import AEPMessaging

// AEPOptimize is required for in-app messaging
//step-optimize-start
import AEPOptimize
//step-optimize-end

import UserNotifications    // for local notification demonstration purposes only
//step-messaging-end



import AEPUserProfile

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

   

    /// APP ID - APP and EDGE CONFIGURATION
    /// APP ID is also called ENVIRONMENT_FILE_ID in the data-collection UI
    ///
    /// Production
    ///1. Org : "Assets Departmental - Campaign "
    ///2. Tag Name : " AEPSampleApp - DO NOT…sample-app-ios"
    ///2.a Note the edge configuration in the above tag, it uses sandbox:Prod, Datastream: "AEPSampleApp Messaging Datastream"
    ///3. Tag - environment_file_id : ""3149c49c3910/6a68c2e19c81/launch-4b2394565377-development"
    ///
    ///
    ///
    /// Stage
    /// 1. Org : "CJM-stage"
    /// 2. Tag Name : AEPSampleAppStageByArchana
    /// 2.a Note the edge configuration in the above tag, it uses sandbox:'AJO web', Datastream:'ArchanaIAM_DataStream'
    /// 3. Tag - environment_file_id : "staging/1b50a869c4a2/0f983a6f9f80/launch-c5682c2fe9a1-development"
    /// 4. If using Stage - please make sure to uncomment the 'cjmStageConfig' present later in this file
    ///
    ///
    /// Please use one of the above environment_file_id
    private let ENVIRONMENT_FILE_ID = "3149c49c3910/6a68c2e19c81/launch-4b2394565377-development"
    
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // step-init-start
        MobileCore.setLogLevel(.trace)
        let appState = application.applicationState;
        let extensions = [
            Lifecycle.self,
            Signal.self,
            Edge.self,
            Consent.self,
            //AEPIdentity.Identity.self,
            AEPEdgeIdentity.Identity.self,
            UserProfile.self,
            //step-extension-start
            SampleExtension.self,
            //step-extension-end
            // step-assurance-start
            Assurance.self,
            // step-assurance-end
            Messaging.self,
            Optimize.self
        ]

        MobileCore.registerExtensions(extensions, {
            // Use the App id assigned to this application via Adobe Launch
            MobileCore.configureWith(appId: self.ENVIRONMENT_FILE_ID)
            // Use the sandbox configuration to allow the messaging sdk to use apnsSandbox
            MobileCore.updateConfigurationWith(configDict: ["messaging.useSandbox" : true])
            if appState != .background {
                // only start lifecycle if the application is not in the background
                MobileCore.lifecycleStart(additionalContextData: ["contextDataKey": "contextDataVal"])
            }
        })
        // step-init-end
        
        // update config to use cjmstage for int integration
        //let cjmStageConfig = [
        //    "edge.environment": "int",
      //  ]
        //MobileCore.updateConfigurationWith(configDict: cjmStageConfig)

        // register push notification
        registerForPushNotifications(application: application) {
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 1) {
                AdIdUtils.requestTrackingAuthorization()
            }
        }
        
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
    
    // MARK: Registration for push notification
    
    /// Requests permissions for remote notifications for the application, and calls the completion handler when the operation is complete in order to allow for request chaining (completion handler is called regardless of authorization status given)
    ///
    /// - Parameters:
    ///     - application: the application instance that notifications will be registered to
    ///     - completionHandler: called when the registration process is completed, regardless of permissions granted; allows of chaining of requests
    func registerForPushNotifications(application: UIApplication, completionHandler: @escaping ()->() = {}) {
        let center = UNUserNotificationCenter.current()
      
        //Ask for user permission
        center.requestAuthorization(options: [.badge, .sound, .alert]) { [weak self] granted, _ in
            defer { completionHandler() }
            guard granted else { return }
            
            center.delegate = self
            
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
        }
    }

    // Tells the delegate that the app successfully registered with Apple Push Notification service (APNs).
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")

        // Send push token to experience platform
        MobileCore.setPushIdentifier(deviceToken)
    }

    // Tells the delegate that the app failed to register with Apple Push Notification service (APNs).
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error)")
        MobileCore.setPushIdentifier(nil)
    }

    // MARK: - Handle Push Notification Interactions
    // Receiving Notifications
    // Delegate method to handle a notification that arrived while the app was running in the foreground.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }

    // Handling the Selection of Custom Actions
    // Delegate method to process the user's response to a delivered notification.
    func userNotificationCenter(_: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        // Perform the task associated with the action.
        switch response.actionIdentifier {
        case "ACCEPT_ACTION":
            Messaging.handleNotificationResponse(response, applicationOpened: true, customActionId: "ACCEPT_ACTION")

        case "DECLINE_ACTION":
            Messaging.handleNotificationResponse(response, applicationOpened: false, customActionId: "DECLINE_ACTION")

            // Handle other actions…
        default:
            Messaging.handleNotificationResponse(response, applicationOpened: true, customActionId: nil)
        }

        // Always call the completion handler when done.
        completionHandler()
    }
}
