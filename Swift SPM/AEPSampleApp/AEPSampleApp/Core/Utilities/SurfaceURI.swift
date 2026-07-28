//
//  SurfaceURI.swift
//  AEPSampleApp
//
//  Single source of truth for AJO surface URIs — the join key between app
//  code and AJO campaigns for content cards, in-app messages, and the inbox
//  feed. Keeping them typed here prevents stringly-typed drift once the real
//  Messaging SDK requests these surfaces.
//
//  NOTE: the host segment must match the app's bundle identifier configured
//  on the AJO side (com.adobe.AEPSampleApp).
//

import Foundation

enum SurfaceURI {
    // Relative path segments the Messaging SDK expects for `Surface(path:)`.
    // The SDK auto-prepends `mobileapp://<bundleId>/`, so these must match the
    // "Location or path inside the app" configured on the AJO campaign.
    static let home  = "test_cc"
    static let inbox = "inbox"
}
