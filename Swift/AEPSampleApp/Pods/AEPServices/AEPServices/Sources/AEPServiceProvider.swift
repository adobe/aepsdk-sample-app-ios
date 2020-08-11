/*
 Copyright 2020 Adobe. All rights reserved.
 This file is licensed to you under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License. You may obtain a copy
 of the License at http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software distributed under
 the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR REPRESENTATIONS
 OF ANY KIND, either express or implied. See the License for the specific language
 governing permissions and limitations under the License.
 */

import Foundation

public class AEPServiceProvider {
    public static let shared = AEPServiceProvider()

    // Provide thread safety on the getters and setters
    private let queue = DispatchQueue(label: "AEPServiceProvider.barrierQueue")

    private var overrideSystemInfoService: SystemInfoService?
    private var defaultSystemInfoService = ApplicationSystemInfoService()
    private var overrideKeyValueService: NamedCollectionProcessing?
    private var defaultKeyValueService = UserDefaultsNamedCollection()
    private var overrideNetworkService: Networking?
    private var defaultNetworkService = NetworkService()
    private var defaultDataQueueService = DataQueueService.shared
    private var overrideCacheService: Caching?
    private var defaultCacheService = DiskCacheService()
    private var overrideURLService: URLOpening?
    private var defaultURLService = URLService()
    private var defaultLoggingService = LoggingService()

    /// The SystemInfoService, either set externally (override) or the default implementation
    public var systemInfoService: SystemInfoService {
        get {
            return queue.sync {
                return overrideSystemInfoService ?? defaultSystemInfoService
            }
        }
        set {
            queue.async {
                self.overrideSystemInfoService = newValue
            }
        }
    }

    public var namedKeyValueService: NamedCollectionProcessing {
        get {
            return queue.sync {
                return overrideKeyValueService ?? defaultKeyValueService
            }
        }
        set {
            queue.async {
                self.overrideKeyValueService = newValue
            }
        }
    }

    public var networkService: Networking {
        get {
            return queue.sync {
                return overrideNetworkService ?? defaultNetworkService
            }
        }
        set {
            queue.async {
                self.overrideNetworkService = newValue
            }
        }
    }

    public var dataQueueService: DataQueuing {
        return queue.sync {
            return defaultDataQueueService
        }
    }

    public var cacheService: Caching {
        get {
            return queue.sync {
                return overrideCacheService ?? defaultCacheService
            }
        }
        set {
            queue.async {
                self.overrideCacheService = newValue
            }
        }
    }

    public var urlService: URLOpening {
        get {
            return queue.sync {
                return overrideURLService ?? defaultURLService
            }
        }
        set {
            queue.async {
                self.overrideURLService = newValue
            }
        }
    }

    public var loggingService: Logging {
        return queue.sync {
            return defaultLoggingService
        }
    }
}
