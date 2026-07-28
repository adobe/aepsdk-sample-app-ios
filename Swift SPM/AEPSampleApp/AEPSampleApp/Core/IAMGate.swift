//
//  IAMGate.swift
//  AEPSampleApp
//
//  Thread-safe flag that gates in-app message display. The Cart/checkout screen
//  raises it while active; the MessagingDelegate's shouldShowMessage reads it to
//  suppress messages during checkout. Lock-guarded because the delegate is
//  called off the main actor.
//

import Foundation

final class IAMGate: @unchecked Sendable {
    static let shared = IAMGate()
    private init() {}

    private let lock = NSLock()
    private var _suppressed = false

    var isSuppressed: Bool {
        get { lock.lock(); defer { lock.unlock() }; return _suppressed }
        set { lock.lock(); _suppressed = newValue; lock.unlock() }
    }
}
