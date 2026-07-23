//
//  LiveActivityService.swift
//  AEPSampleApp
//
//  Seam for Live Activities. The "order" is mock data; the start/update/end
//  mechanism is real SDK behavior in Stage 3e (ActivityKit +
//  AEPMessagingLiveActivity). Stage 0 just flips a fake active flag.
//

import Foundation

protocol LiveActivityService {
    /// Starts a mock order-tracking activity. Returns false if unsupported
    /// (e.g. Live Activities disabled / simulator limitations in later stages).
    func startOrderTracking() async -> Bool

    func endOrderTracking() async
}
