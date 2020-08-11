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

import UIKit
import SwiftUI
import AEPCore

class AnalyticsViewController: UIHostingController<AnalyticsView> {}

struct AnalyticsView: View {
    enum OptInVal: String {
        case optIn = "Opt In"
        case optOut = "Opt Out"
        case optUnknown = "Opt Unknown"
    }
    var optInPickerData = [OptInVal.optIn, OptInVal.optOut, OptInVal.optUnknown]
    @State private var eventQueueLength: String = ""
    @State private var minBatchSize: String = ""
    @State private var trackingIdentifier: String = ""
    @State private var visitorIdentifier: String = ""
    @State private var batchQueueLimit: String = ""
    @State private var selectedOptInIndex = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                // Status section
                statusSection
                // Manual Event Triggers Section
                manualEventTriggersSection
                // Opting Options Section
                optingOptionsSection
                // Overrides section
                manualOverridesSection
            }.padding()
        }
    }
    
    var statusSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Status").bold()
            HStack {
                Text("Event Queue Length:")
                Text(eventQueueLength)
            }
            HStack {
                Text("Min Batch Size:")
                Text(minBatchSize)
            }
            HStack {
                Text("Tracking Identifier:")
                Text(trackingIdentifier)
            }
            HStack {
                Text("Visitor Identifier:")
                Text(visitorIdentifier)
            }
        }
    }
    
    var manualEventTriggersSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Manual Event Triggers").bold()
            HStack {
                Button(action: {
//                    ACPAnalytics.sendQueuedHits()
                }){
                    Text("Send Queued Hits")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .font(.caption)
                }
                Button(action: {
//                    ACPAnalytics.clearQueue()
                }) {
                    Text("Clear Queue")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .font(.caption)
                }
            }
            HStack {
                Button(action: {
//                    ACPCore.trackAction("sampleAction", data: ["exampleKey": "exampleValue"])
                }){
                    Text("Send trackAction Event")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .font(.caption)
                }
                Button(action: {
//                    ACPCore.trackState("sampleState", data: ["exampleKey": "exampleValue"])
                }) {
                    Text("Send trackState Event")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .font(.caption)
                }
            }
        }
    }
    
    var optingOptionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Opting Options").bold()
            Picker(selection: $selectedOptInIndex, label: Text("Opt Value Picker"), content: {
                ForEach(0 ..< optInPickerData.count) {
                    Text(self.optInPickerData[$0].rawValue)
                }
            })
        }
    }
    
    var manualOverridesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Overrides").bold()
            TextField("Visitor Identifier", text: $visitorIdentifier)
            TextField("Batch Queue Limit", text: $batchQueueLimit)
            Button(action: {
//                ACPAnalytics.setVisitorIdentifier(visitorIdentifier)
//                ACPAnalytics.getTrackingIdentifier { id in
//                    trackingIdentifier = id ?? "<none>"
//                }
//                ACPAnalytics.getVisitorIdentifier { id in
//                    visitorIdentifier = id ?? "<none>"
//                }
                let batchInt = Int(self.batchQueueLimit) ?? 0
                let dataDict = ["analytics.batchLimit": batchInt]
                MobileCore.updateConfigurationWith(configDict: dataDict)
//                ACPAnalytics.getQueueSize { size in
//                    eventQueueLength = String(size)
//                }
            }) {
                Text("Update")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .font(.caption)
            }
        }
    }
}

// TODO: - remove just used for testing
class ACPAnalytics {
    static func setVisitorIdentifier(id: String) {
        print(id)
    }
}

// send queued hits button tapped
// clear queue button tapped
// send track action event button tapped
// send track state event button tapped
// update button tapped

// picker view delegate
// picker view dasta source


