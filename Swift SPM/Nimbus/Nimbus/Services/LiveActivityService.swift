//
//  LiveActivityService.swift
//  Nimbus
//
//  Seam for Live Activities. The "order" is mock data; the start/update/end
//  mechanism is real (ActivityKit + AEPMessagingLiveActivity).
//

protocol LiveActivityService {
    /// Starts a mock order-tracking activity at step `.placed`.
    /// Returns false if unsupported (Live Activities disabled / Simulator).
    func startOrderTracking() async -> Bool

    func endOrderTracking() async

    /// Advances the running activity to the next OrderStep and pushes an
    /// ActivityKit content update. Returns the new step, or nil if already
    /// at the terminal step or no activity is running.
    func advanceStep() async -> OrderStep?

    /// Synchronously reads the current step from the running activity, if any.
    func currentStep() -> OrderStep?

    /// Returns a snapshot of all currently running order activities on this device.
    func activeActivities() -> [ActiveActivityInfo]
}

struct ActiveActivityInfo: Identifiable {
    let id: String           // ActivityKit activity id
    let orderNumber: String
    let liveActivityID: String
    let step: OrderStep
    let etaMinutes: Int
}
