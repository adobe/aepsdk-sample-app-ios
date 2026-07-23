//
//  InspectorPayload.swift
//  AEPSampleApp
//
//  The single data shape consumed by the reusable InspectorSheet. Every
//  personalized/messaged surface (personalized card, content cards, inbox
//  rows, cart badge) builds one of these to make invisible SDK plumbing
//  visible during a demo.
//

import Foundation

struct InspectorPayload: Identifiable {
    let id = UUID()
    let title: String
    let source: String         // decision scope name / surface URI / "session"
    let json: String           // pretty-printed payload
    let tracking: [String]     // tracking calls fired for this element
}
