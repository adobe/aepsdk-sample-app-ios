//
//  DevConsoleViewModel.swift
//  AEPSampleApp
//
//  Thin coordinator for the Dev Console: launches an Assurance session from a
//  pasted session URL and exposes the registered extensions. The live log is
//  read directly from EventLog.shared in the view.
//

import Foundation
import Observation

@Observable
final class DevConsoleViewModel {
    private(set) var launched = false

    func connect(urlString: String, _ env: AppEnvironment) {
        let trimmed = urlString.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let url = URL(string: trimmed) else { return }
        env.diagnostics.startSession(url: url)
        launched = true
    }

    func extensions(_ env: AppEnvironment) -> [ExtensionInfo] {
        env.diagnostics.registeredExtensions
    }
}
