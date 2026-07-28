//
//  InboxMessage.swift
//  AEPSampleApp
//
//  App-owned inbox/feed model. Cards come from a real AJO feed surface, but
//  read/dismissed state is persisted locally (InboxStore) because the SDK does
//  not persist it across launches.
//

import Foundation

struct InboxMessage: Identifiable, Hashable {
    let id: String
    let title: String
    let body: String
    let receivedAt: Date
    var isRead: Bool
    let surface: String
}
