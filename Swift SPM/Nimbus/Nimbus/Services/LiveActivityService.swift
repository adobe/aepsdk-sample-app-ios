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

    /// Emits the running activity's step whenever its content state changes —
    /// from a local update() OR a remote AJO content-state push — and nil when the
    /// activity ends. Lets the app mirror ActivityKit into its own in-app card so
    /// that card stays in sync with the Dynamic Island / Lock Screen (which
    /// ActivityKit renders directly). Long-lived — the stream never finishes.
    func stepUpdates() -> AsyncStream<OrderStep?>

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
