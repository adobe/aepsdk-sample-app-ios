/*
 Copyright 2020 Adobe
 All Rights Reserved.
 
 NOTICE: Adobe permits you to use, modify, and distribute this file in
 accordance with the terms of the Adobe license agreement accompanying
 it.
 */

import UIKit
import SwiftUI
import AEPCore
import AEPIdentity

class CoreViewController: UIHostingController<CoreView> {}

struct CoreView: View {
    @State private var eventQueueLength: String = ""
    @State private var minBatchSize: String = ""
    @State private var trackingIdentifier: String = ""
    @State private var visitorIdentifier: String = ""
    @State private var batchQueueLimit: String = ""
    @State private var selectedOptInIndex = 0
    @State private var currentPrivacyStatus: String = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                privacySection
                piiSection
                manualOverridesSection
                eventsSection
                identitySection
            }.padding()
        }
    }
    
    
    var privacySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Change Privacy Status").bold()
            Button(action: {
                MobileCore.setPrivacy(status: .optedIn)
            }) {
                Text("Opted In")
            }.buttonStyle(CustomButtonStyle())
            
            Button(action: {
                MobileCore.setPrivacy(status: .optedOut)
            }) {
                Text("Opted Out")
            }.buttonStyle(CustomButtonStyle())
            
            Button(action: {
                MobileCore.setPrivacy(status: .unknown)
            }) {
                Text("Unknown")
            }.buttonStyle(CustomButtonStyle())
            
            HStack {
                Button(action: {
                    MobileCore.getPrivacyStatus { privacyStatus in
                        self.currentPrivacyStatus = "\(privacyStatus.rawValue)"
                    }
                }) {
                    Text("Get Privacy")
                }.buttonStyle(CustomButtonStyle())
                VStack{
                    
                    Text("Current Privacy:")
                    Text(currentPrivacyStatus)
                }
            }
        }
    }
    
    var piiSection: some View {
        
        VStack(alignment: .leading, spacing: 12) {
            Text("Collect PII").bold()
            Button(action: {
                MobileCore.collectPii(data: ["name":"Adobe Experience Platform"])
            }){
                Text("Collect PII")
            }.buttonStyle(CustomButtonStyle())
        }
    }
    
    
    var manualOverridesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Update Configuration").bold()
            Button(action: {
                let dataDict = ["analytics.batchLimit": 3]
                MobileCore.updateConfigurationWith(configDict: dataDict)
            }) {
                Text("Update Configuration")
            }.buttonStyle(CustomButtonStyle())
        }
    }
    
    var eventsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Dispatch Events").bold()
            Button(action: {
                let event = Event(name: "Sample Event", type: "type", source: "source", data: ["platform" : "ios"])
                MobileCore.dispatch(event: event)
            }) {
                Text("Dispatch Custom Event")
            }.buttonStyle(CustomButtonStyle())
            
            Button(action: {
                let event = Event(name: "Sample Event", type: "type", source: "source", data: ["platform" : "ios"])
                MobileCore.dispatch(event: event) { event in
                    
                }
            }) {
                Text("Dispatch Custom Event with response callback")
            }.buttonStyle(CustomButtonStyle())
        }
    }
    
    var identitySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Identity APIs").bold()
            Button(action: {
                MobileCore.setAdvertisingIdentifier(adId: "advertisingIdentifier")
            }) {
                Text("Set Advertising Identifier")
            }.buttonStyle(CustomButtonStyle())
            
            Button(action: {
                MobileCore.setPushIdentifier(deviceToken: "9516258b6230afdd93cf0cd07b8dd845".data(using: .utf8))
            }) {
                Text("Set Push Identifier")
            }.buttonStyle(CustomButtonStyle())
            
            Button(action: {
                Identity.syncIdentifiers(identifiers: ["idType1":"1234567"], authenticationState: .authenticated)
            }) {
                Text("Sync Identifiers")
            }.buttonStyle(CustomButtonStyle())
            
            Button(action: {
                Identity.getExperienceCloudId { ecid in
                    print(ecid ?? "")
                }
            }) {
                Text("Get ExperienceCloudId")
            }.buttonStyle(CustomButtonStyle())
            
            
            Button(action: {
                MobileCore.getSdkIdentities { identities, _ in
                    print(identities ?? "")
                }
            }) {
                Text("Get Sdk Identities")
            }.buttonStyle(CustomButtonStyle())
            
            Button(action: {
                Identity.getUrlVariables { variables, error in
                    print(variables ?? "")
                }
            }) {
                Text("Get Url Variables")
            }.buttonStyle(CustomButtonStyle())
            
            Button(action: {
                Identity.appendTo(url: URL(string: "https://example.com")) { url, _ in
                    
                    print(url?.absoluteString ?? "")
                }
            }) {
                Text("Append Url")
            }.buttonStyle(CustomButtonStyle())
        }
    }
    
}

