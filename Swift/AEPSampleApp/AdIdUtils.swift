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
    
    /// Provides the `advertisingIdentifier` for the given environment, assuming tracking authorization is provided
    ///
    /// Simulators will never provide a valid UUID, regardless of authorization; use the set ad ID flow to test a specific ad ID.
    static func getAdvertisingIdentifierForEnvironment() -> UUID {
        #if targetEnvironment(simulator)
        print("""
            Simulator environment detected. Please note that simulators cannot retrieve valid advertising identifier
            from the ASIdentifierManager (as specified by Apple); an all-zeros UUID will be retrieved even if
            authorization is provided. If you want to use a specific ad ID, you can use the set ad ID flow.
            """)
        #endif
        print("Advertising identifier: \(ASIdentifierManager.shared().advertisingIdentifier)")
        return ASIdentifierManager.shared().advertisingIdentifier
    }
    
    /// Requests tracking authorization from the user; prompt will only be shown once per app install, as per Apple rules
    ///
    /// It is possible to change tracking permissions at the Settings app level. Any change in tracking permissions will terminate the app.
    /// It is also possible for system-wide tracking to be off but individual per-app permissions granted.
    /// If "Allow Apps to Request to Track" at the system level was on and is turned off, a system prompt appears asking if previously provided individual per-app tracking permissions should be kept as-is or all turned off
    static func requestTrackingAuthorization() {
        // ATTrackingManager only available in iOS 14+
        // Requires Xcode 12 and AppTrackingTransparency framework
        if #available(iOS 14, *) {
            print("Calling requestTrackingAuthorization. Dialog will only be shown once per app install.")
            ATTrackingManager.requestTrackingAuthorization { status in
                print("Request tracking authorization status is '\(status)'.")
                let adID = getAdvertisingIdentifierForEnvironment()
                print("Advertising identifier: \(adID)")
                switch status {
                // Tracking authorization dialog was shown and authorization given
                case .authorized:
                    // IDFA now accessible
                    print("\(status)")
                // For all cases below (that is, not .authorized), IDFA is all-zeros
                // Tracking authorization dialog was shown and permission is denied
                case .denied:
                    print("\(status)")
                // Tracking authorization dialog has not been shown
                case .notDetermined:
                    print("\(status)")
                // Tracking authorization dialog is not allowed to be shown
                case .restricted:
                    print("\(status)")
                @unknown default:
                    print("\(status)")
                }
            }
        } else {
            // ASIdentifierManager used for iOS <= 13
            print("""
                  iOS version <= 13 detected. ATTrackingManager's requestTrackingAuthorization is not available; using ASIdentifierManager and getting IDFA directly.
                  ASIdentifierManager.shared().isAdvertisingTrackingEnabled: \(ASIdentifierManager.shared().isAdvertisingTrackingEnabled)
                  Advertising identifier: \(getAdvertisingIdentifierForEnvironment())
                  """)
            print("Tracking authorization status is '\(ASIdentifierManager.shared().isAdvertisingTrackingEnabled)'.")
            if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
                // IDFA now accessible
                let adID = getAdvertisingIdentifierForEnvironment()
                print("Advertising identifier: \(adID)")
            } else {
                // IDFA is all-zeros
                let adID = getAdvertisingIdentifierForEnvironment()
                print("Advertising identifier: \(adID)")
            }
        }
    }
}
