//
//  LiveActivityService.swift
//  Nimbus
//
//  Seam for Live Activities. The "order" is mock data; the start/update/end
//  mechanism is real (ActivityKit + AEPMessagingLiveActivity).
//

protocol LiveActivityService {
    /// Starts a mock order-tracking activity. Returns false if unsupported
    /// (e.g. Live Activities disabled / Simulator limitations).
    func startOrderTracking() async -> Bool

    func endOrderTracking() async
}
