//
//  AEPConfig.swift
//  Nimbus
//
//  Single source for SDK configuration. The App ID is the Data Collection
//  mobile property (Development environment); swap per environment here only.
//

import AEPCore
import AEPServices

enum AEPConfig {
    static let appId = "3149c49c3910/0f12baf27522/launch-0d096c129660-development"

    // .trace for dev; drop to .warning for release builds.
    static let logLevel: LogLevel = .debug
}
