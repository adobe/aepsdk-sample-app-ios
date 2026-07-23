//
//  AppDelegate.swift
//  AEPSampleApp
//
//  Registers the AEP extensions at launch, wires the push notification-center
//  delegate, and forwards the APNs device token to the SDK. Stays free of any
//  Adobe import — all SDK work is routed through AEPBootstrapper / PushManager.
//

import UIKit
import UserNotifications

final class AppDelegate: NSObject, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        AEPBootstrapper.start()
        UNUserNotificationCenter.current().delegate = PushManager.shared
        return true
    }

    // APNs registration succeeded — hand the token to the SDK.
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        PushManager.shared.setDeviceToken(deviceToken)
    }

    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        Log.sdk("didFailToRegisterForRemoteNotifications: \(error.localizedDescription)")
    }
}
