//
//  Logger.swift
//  AEPSampleApp
//
//  Single logging facade for the whole app. Marked `nonisolated` so it can be
//  called from any context (SDK delegate callbacks run off the main actor).
//  The in-app Dev Console mirror hops to the main actor itself.
//

import OSLog

enum Log {
    nonisolated private static let logger = Logger(subsystem: "com.adobe.AEPSampleApp", category: "app")

    nonisolated static func sdk(_ message: String) {
        logger.info("📡 \(message, privacy: .public)")
        // Mirror into the in-app Dev Console log.
        Task { @MainActor in EventLog.shared.record(message) }
    }

    nonisolated static func ui(_ message: String) {
        logger.debug("🖼️ \(message, privacy: .public)")
    }
}
