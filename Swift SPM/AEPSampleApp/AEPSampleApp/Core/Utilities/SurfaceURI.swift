//
//  SurfaceURI.swift
//  AEPSampleApp
//
//  Single source of truth for AJO surface URIs — the join key between app
//  code and AJO campaigns for content cards, in-app messages, and the inbox
//  feed. Keeping them typed here prevents stringly-typed drift once the real
//  Messaging SDK requests these surfaces (Stage 3).
//
//  NOTE: the host segment must match the app's bundle identifier configured
//  on the AJO side (com.adobe.AEPSampleApp).
//

import Foundation

enum SurfaceURI {
    static let base = "mobileapp://com.adobe.AEPSampleApp"

    static let home  = "\(base)/home"
    static let inbox = "\(base)/inbox"
}
