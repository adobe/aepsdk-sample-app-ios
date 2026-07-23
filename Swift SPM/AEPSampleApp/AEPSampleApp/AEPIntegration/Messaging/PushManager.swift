//
//  PushManager.swift
//  AEPSampleApp
//
//  Owns the APNs/push plumbing: notification-authorization prompt, remote
//  registration, forwarding the device token to the SDK
//  (MobileCore.setPushIdentifier), and routing notification interactions to
//  Messaging.handleNotificationResponse for click-through tracking.
//
//  Single instance because there is exactly one UNUserNotificationCenter
//  delegate for the app; AppDelegate wires it and AEPMessagingService reads it.
//

import Foundation
import UIKit
import UserNotifications
import AEPCore
import AEPMessaging

final class PushManager: NSObject, UNUserNotificationCenterDelegate {

    static let shared = PushManager()
    private override init() {}

    // MARK: Authorization + registration

    func currentStatus() async -> PushStatus {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        return Self.map(settings.authorizationStatus)
    }

    func request() async -> PushStatus {
        let center = UNUserNotificationCenter.current()
        let granted = (try? await center.requestAuthorization(options: [.alert, .badge, .sound])) ?? false
        if granted {
            // Must run on the main thread.
            UIApplication.shared.registerForRemoteNotifications()
        }
        Log.sdk("push authorization requested -> granted=\(granted)")
        return await currentStatus()
    }

    // MARK: Token

    func setDeviceToken(_ token: Data) {
        MobileCore.setPushIdentifier(token)
        Log.sdk("setPushIdentifier (\(token.count) bytes)")
    }

    // MARK: UNUserNotificationCenterDelegate

    /// Show notifications while the app is foregrounded.
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        [.banner, .badge, .sound]
    }

    /// User tapped / actioned a notification — forward to Messaging so AJO
    /// records the click-through.
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {
        Messaging.handleNotificationResponse(response)
        Log.sdk("handleNotificationResponse action=\(response.actionIdentifier)")
    }

    // MARK: Helpers

    private static func map(_ status: UNAuthorizationStatus) -> PushStatus {
        switch status {
        case .notDetermined:                       return .notRequested
        case .authorized, .provisional, .ephemeral: return .granted
        case .denied:                              return .denied
        @unknown default:                          return .notRequested
        }
    }
}
