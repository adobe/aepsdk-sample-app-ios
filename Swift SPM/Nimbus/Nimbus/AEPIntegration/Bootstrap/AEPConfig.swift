//
//  AEPConfig.swift
//  Nimbus
//
//  Single source for SDK configuration. The App ID is the Data Collection
//  mobile property (Development environment); swap per environment here only.
//

import AEPCore
import AEPServices   // LogLevel lives here

enum AEPConfig {
    static let appId = "3149c49c3910/e2e20a36b6cf/launch-78df58a45342-development"

    // .trace for dev; drop to .warning for release builds.
    static let logLevel: LogLevel = .debug
}
