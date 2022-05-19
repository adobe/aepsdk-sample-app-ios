/*
 Copyright 2022 Adobe
 All Rights Reserved.
 
 NOTICE: Adobe permits you to use, modify, and distribute this file in
 accordance with the terms of the Adobe license agreement accompanying
 it.
 */

import AdSupport
import AppTrackingTransparency
import Foundation

class AdIdUtils {
    
    /// Provides the `advertisingIdentifier` for the given environment, assuming tracking authorization is provided.
    /// Use ``requestTrackingAuthorization(callbackHandler:)`` to request authorization.
    ///
    /// Simulators may not provide a valid `UUID`, regardless of authorization state; in this case, use the set ad ID flow to test a specific
    /// ad ID instead. Please see Apple's documentation on `advertisingIdentifier` for more details:
    /// https://developer.apple.com/documentation/adsupport/asidentifiermanager/1614151-advertisingidentifier
    ///
    /// - Returns: The IDFA in `UUID` format; all-zeros if tracking is not authorized or in simulator environment
    static func getAdvertisingIdentifierForEnvironment() -> UUID {
        #if targetEnvironment(simulator)
        print("""
            Simulator environment detected; an all-zeros UUID will be retrieved even if
            authorization is provided. Use the set ad ID flow to set a specific ad ID value.
            """)
        #endif
        print("Advertising identifier: \(ASIdentifierManager.shared().advertisingIdentifier)")
        return ASIdentifierManager.shared().advertisingIdentifier
    }
    
    /// Checks if ad ID tracking authorization is provided, if not returns `false`. Handles both iOS 14+ and iOS < 14,
    /// using the appropriate APIs for each case
    ///
    /// - Returns: `true` if authorized, `false` for any other state
    static func isTrackingAuthorized() -> Bool {
        if #available(iOS 14, *) {
            print("Tracking authorization status: \(ATTrackingManager.trackingAuthorizationStatus)")
            return ATTrackingManager.trackingAuthorizationStatus == .authorized
        } else {
            print("iOS version < 14 detected; using ASIdentifierManager and getting IDFA directly.")
            print("Tracking authorization status: \(ASIdentifierManager.shared().isAdvertisingTrackingEnabled)")
            return ASIdentifierManager.shared().isAdvertisingTrackingEnabled
        }
    }
    
    /// Requests tracking authorization from the user; prompt will only be shown once per app install, as per Apple rules
    ///
    /// - Parameters:
    ///     - callbackHandler: Called after authorization flow completes, to allow for request chaining
    static func requestTrackingAuthorization(callbackHandler: @escaping ()->() = {}) {
        if #available(iOS 14, *) {
            print("Calling requestTrackingAuthorization. Dialog will only be shown once per app install.")
            ATTrackingManager.requestTrackingAuthorization { status in
                print("Request tracking authorization status is '\(status)'.")
                switch status {
                // Tracking authorization dialog was shown and authorization given
                case .authorized:
                    // IDFA now accessible
                    print("Authorization status: \(status)")
                // For all cases below (that is, not .authorized), IDFA is all-zeros
                // Tracking authorization dialog was shown and permission is denied
                case .denied:
                    print("Authorization status: \(status)")
                // Tracking authorization dialog has not been shown
                case .notDetermined:
                    print("Authorization status: \(status)")
                // Tracking authorization dialog is not allowed to be shown; not controlled by the user
                case .restricted:
                    print("Authorization status: \(status)")
                @unknown default:
                    print("Authorization status: \(status)")
                }
                callbackHandler()
            }
        } else {
            // iOS version < 14 does not use ad ID tracking authorization; see Apple guidance on using
            // advertisingIdentifier: https://developer.apple.com/documentation/adsupport/asidentifiermanager/1614151-advertisingidentifier
            callbackHandler()
        }
    }
}
