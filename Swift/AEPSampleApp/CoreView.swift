/*
 Copyright 2020 Adobe
 All Rights Reserved.
 
 NOTICE: Adobe permits you to use, modify, and distribute this file in
 accordance with the terms of the Adobe license agreement accompanying
 it.
 */

import UIKit
import SwiftUI

// step-config-start
import AEPCore
// step-config-end

// step-identity-start
import AEPIdentity
// step-identity-end

import AEPUserProfile

struct CoreView: View {
    @State private var eventQueueLength: String = ""
    @State private var minBatchSize: String = ""
    @State private var trackingIdentifier: String = ""
    @State private var visitorIdentifier: String = ""
    @State private var batchQueueLimit: String = ""
    @State private var selectedOptInIndex = 0
    @State private var currentPrivacyStatus: String = ""
    @State private var showingAlert = false
    @State private var retrievedAttributes: String = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                privacySection
                piiSection
                manualOverridesSection
                eventsSection
                identitySection
                profileSection
            }.padding()
        }.onAppear() {
            MobileCore.track(state: "CoreView", data:nil)
        }
    }
    var profileSection: some View {
        
        VStack(alignment: .leading, spacing: 12) {
            Text("User Profile").bold()
            Button(action: {
                UserProfile.updateUserAttributes(attributeDict: ["user_name":"Will Smith"])
            }){
                Text("Update Attributes")
            }.buttonStyle(CustomButtonStyle())
            Button(action: {
                UserProfile.getUserAttributes(attributeNames: ["user_name"]){
                    attributes, error in
                        self.showingAlert = true
                        self.retrievedAttributes = String(describing: attributes)
                }
            }){
                Text("Retrieve Attributes")
            }.buttonStyle(CustomButtonStyle())
            .alert(isPresented: $showingAlert){
                Alert(title: Text("Profile"),message: Text(self.retrievedAttributes),dismissButton: .default(Text("Got it!")))
            }
            Button(action: {
                UserProfile.removeUserAttributes(attributeNames: ["user_name"])
            }){
                Text("Remove Attributes")
            }.buttonStyle(CustomButtonStyle())
        }
    }

    var privacySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Change Privacy Status").bold()
            Button(action: {
                // step-privacy-start
                MobileCore.setPrivacyStatus(.optedIn)
                // step-privacy-end
            }) {
                Text("Opted In")
            }.buttonStyle(CustomButtonStyle())
            
            Button(action: {
                // step-privacy-start
                MobileCore.setPrivacyStatus(.optedOut)
                // step-privacy-end
            }) {
                Text("Opted Out")
            }.buttonStyle(CustomButtonStyle())
            
            Button(action: {
                // step-privacy-start
                MobileCore.setPrivacyStatus(.unknown)
                // step-privacy-end
            }) {
                Text("Unknown")
            }.buttonStyle(CustomButtonStyle())
            
            HStack {
                Button(action: {
                    // step-privacy-start
                    MobileCore.getPrivacyStatus { privacyStatus in
                        self.currentPrivacyStatus = "\(privacyStatus.rawValue)"
                    }
                    // step-privacy-end
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
                // step-pii-start
                MobileCore.collectPii(["name":"Adobe Experience Platform"])
                // step-pii-end
            }){
                Text("Collect PII")
            }.buttonStyle(CustomButtonStyle())
        }
    }
    
    
    var manualOverridesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Update Configuration").bold()
            Button(action: {
                // step-config-start
                let dataDict = ["analytics.batchLimit": 3]
                MobileCore.updateConfigurationWith(configDict: dataDict)
                // step-config-end
            }) {
                Text("Update Configuration")
            }.buttonStyle(CustomButtonStyle())
        }
    }
    
    var eventsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Dispatch Events").bold()
            Button(action: {
                // step-event-start
                let event = Event(name: "Sample Event", type: "type", source: "source", data: ["platform" : "ios"])
                MobileCore.dispatch(event: event)
                // step-event-end
            }) {
                Text("Dispatch Custom Event")
            }.buttonStyle(CustomButtonStyle())
            
            Button(action: {
                // step-event-start
                let event = Event(name: "Sample Event", type: "type", source: "source", data: ["platform" : "ios"])
                MobileCore.dispatch(event: event) { event in
                    
                }
                // step-event-end
            }) {
                Text("Dispatch Custom Event with response callback")
            }.buttonStyle(CustomButtonStyle())
        }
    }
    
    var identitySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Identity APIs").bold()
            Button(action: {
                // step-identity-start
                MobileCore.setAdvertisingIdentifier("advertisingIdentifier")
                // step-identity-end
            }) {
                Text("Set Advertising Identifier")
            }.buttonStyle(CustomButtonStyle())
            
            Button(action: {
                // step-identity-start
                MobileCore.setPushIdentifier("9516258b6230afdd93cf0cd07b8dd845".data(using: .utf8))
                // step-identity-end
            }) {
                Text("Set Push Identifier")
            }.buttonStyle(CustomButtonStyle())
            
            Button(action: {
                // step-identity-start
                Identity.syncIdentifiers(identifiers: ["idType1":"1234567"], authenticationState: .authenticated)
                // step-identity-end
            }) {
                Text("Sync Identifiers")
            }.buttonStyle(CustomButtonStyle())
            
            Button(action: {
                // step-identity-start
                Identity.getExperienceCloudId { ecid, error in
                    print(ecid ?? "")
                }
                // step-identity-end
            }) {
                Text("Get ExperienceCloudId")
            }.buttonStyle(CustomButtonStyle())
            
            
            Button(action: {
                // step-identity-start
                MobileCore.getSdkIdentities { identities, _ in
                    print(identities ?? "")
                }
                // step-identity-end
            }) {
                Text("Get Sdk Identities")
            }.buttonStyle(CustomButtonStyle())
            
            Button(action: {
                // step-identity-start
                Identity.getUrlVariables { variables, error in
                    print(variables ?? "")
                }
                // step-identity-end
            }) {
                Text("Get Url Variables")
            }.buttonStyle(CustomButtonStyle())
            
            Button(action: {
                // step-identity-start
                Identity.appendTo(url: URL(string: "https://example.com")) { url, _ in
                    
                    print(url?.absoluteString ?? "")
                }
                // step-identity-end
            }) {
                Text("Append Url")
            }.buttonStyle(CustomButtonStyle())
        }
    }
}

struct CoreViewController_Previews: PreviewProvider {
    static var previews: some View {
        CoreView()
    }
}
