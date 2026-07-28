//
//  InboxMessage.swift
//  AEPSampleApp
//
//  App-owned inbox/feed model. The cards themselves come from a real AJO
//  feed surface (Stage 3), but read/dismissed state is persisted locally
//  because the SDK does not persist it across launches.
//

import Foundation

struct InboxMessage: Identifiable, Hashable {
    let id: String
    let title: String
    let body: String
    let receivedAt: Date
    var isRead: Bool
    let surface: String          // e.g. mobileapp://<bundle>/inbox   so 'inbox' is a surface
    let rawJSON: String
}
