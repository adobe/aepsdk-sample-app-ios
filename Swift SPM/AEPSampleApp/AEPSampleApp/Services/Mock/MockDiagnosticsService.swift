//
//  MockDiagnosticsService.swift
//  AEPSampleApp
//
//  Offline stand-in used by AppEnvironment.mock(). Logs instead of touching
//  the SDK; the real impl is AEPDiagnosticsService.
//

import Foundation

final class MockDiagnosticsService: DiagnosticsService {
    func startSession(url: URL) {
        Log.sdk("Assurance.startSession (mock) \(url.absoluteString)")
    }

    func endSession() {
        Log.sdk("Assurance endSession (mock)")
    }
}
