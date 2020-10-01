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
            }) {
                Text("Opted In")
            }.buttonStyle(CustomButtonStyle())
            
            Button(action: {
            }) {
                Text("Opted Out")
            }.buttonStyle(CustomButtonStyle())
            
            Button(action: {
            }) {
                Text("Unknown")
            }.buttonStyle(CustomButtonStyle())
            
            HStack {
                Button(action: {
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
            }){
                Text("Collect PII")
            }.buttonStyle(CustomButtonStyle())
        }
    }
    
    
    var manualOverridesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Update Configuration").bold()
            Button(action: {
            }) {
                Text("Update Configuration")
            }.buttonStyle(CustomButtonStyle())
        }
    }
    
    var eventsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Dispatch Events").bold()
            Button(action: {
            }) {
                Text("Dispatch Custom Event")
            }.buttonStyle(CustomButtonStyle())
            
            Button(action: {
                
                
            }) {
                Text("Dispatch Custom Event with response callback")
            }.buttonStyle(CustomButtonStyle())
        }
    }
    
    var identitySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Identity APIs").bold()
            Button(action: {
            }) {
                Text("Set Advertising Identifier")
            }.buttonStyle(CustomButtonStyle())
            
            Button(action: {
            }) {
                Text("Set Push Identifier")
            }.buttonStyle(CustomButtonStyle())
            
            Button(action: {
            }) {
                Text("Sync Identifiers")
            }.buttonStyle(CustomButtonStyle())
            
            Button(action: {
            }) {
                Text("Get ExperienceCloudId")
            }.buttonStyle(CustomButtonStyle())
            
            
            Button(action: {
            }) {
                Text("Get Sdk Identities")
            }.buttonStyle(CustomButtonStyle())
            
            Button(action: {
            }) {
                Text("Get Url Variables")
            }.buttonStyle(CustomButtonStyle())
            
            Button(action: {
            }) {
                Text("Append Url")
            }.buttonStyle(CustomButtonStyle())
        }
    }
    
}

