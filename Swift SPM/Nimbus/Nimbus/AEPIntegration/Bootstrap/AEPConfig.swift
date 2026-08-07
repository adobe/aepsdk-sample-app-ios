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
//    static let appId = "3149c49c3910/e2e20a36b6cf/launch-78df58a45342-development"
    static let appId = "3149c49c3910/0f12baf27522/launch-0d096c129660-development"
//    static let appId = "3149c49c3910/0787634fbbda/launch-665249bfef61-development"
//    static let appId = "3149c49c3910/ad4ab1ab79df/launch-4a5f9f09d6e6-development"


    // .trace for dev; drop to .warning for release builds.
    static let logLevel: LogLevel = .debug
}
