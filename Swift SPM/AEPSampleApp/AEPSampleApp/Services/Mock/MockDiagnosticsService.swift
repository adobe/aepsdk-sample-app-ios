//
//  MockDiagnosticsService.swift
//  AEPSampleApp
//
//  Offline stand-in used by AppEnvironment.mock(). Logs instead of touching
//  the SDK; the real impl is AEPDiagnosticsService.
//

import Foundation

final class MockDiagnosticsService: DiagnosticsService {
    let registeredExtensions: [ExtensionInfo] = [
        ExtensionInfo(name: "Mobile Core", version: "not registered"),
        ExtensionInfo(name: "Edge", version: "not registered"),
        ExtensionInfo(name: "Edge Identity", version: "not registered"),
        ExtensionInfo(name: "Edge Consent", version: "not registered"),
        ExtensionInfo(name: "Assurance", version: "not registered"),
    ]

    func startSession(url: URL) {
        Log.sdk("Assurance.startSession (mock) \(url.absoluteString)")
    }

    func endSession() {
        Log.sdk("Assurance endSession (mock)")
    }
}
