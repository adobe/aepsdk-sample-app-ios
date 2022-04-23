/*
 Copyright 2021 Adobe
 All Rights Reserved.
 
 NOTICE: Adobe permits you to use, modify, and distribute this file in
 accordance with the terms of the Adobe license agreement accompanying
 it.
 */

import AEPCore
import AEPEdgeIdentity
import Foundation
import SwiftUI

struct EdgeIdentityView: View {
    @State var currentEcid = ""
    @State var currentIdentityMap: IdentityMap?
    @State var adID: UUID?
    @State var adIdText: String = ""
    @State var trackingAuthorizationResultText: String = ""
    
    /// Updates view for ad ID related elements
    func updateUsingTrackingAuthorization() {
        let isTrackingAuthorized = AdIdUtils.isTrackingAuthorized()
        trackingAuthorizationResultText = isTrackingAuthorized ? "Tracking allowed" : "Tracking not allowed"
        print("isTrackingAuthorized: \(isTrackingAuthorized)")
        if isTrackingAuthorized {
            self.adID = AdIdUtils.getAdvertisingIdentifierForEnvironment()
            print("Advertising identifier fetched: \(adID)")
            MobileCore.setAdvertisingIdentifier(self.adID?.uuidString)
        } else {
            MobileCore.setAdvertisingIdentifier("")
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Button(action: {
                    Identity.getExperienceCloudId { ecid, error in
                        currentEcid = ecid ?? ""
                    }
                    
                }) {
                    Text("Get ExperienceCloudId")
                }.buttonStyle(CustomButtonStyle())
                Text("Current ECID:")
                Text(currentEcid)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .contextMenu {
                        Button(action: {
                            UIPasteboard.general.string = currentEcid
                        }) {
                            Text("Copy")
                            }
                    }
                
                Button(action: {
                    Identity.getIdentities { identityMap, error in
                        currentIdentityMap = identityMap
                    }
                    
                }) {
                    Text("Get Identities")
                }.buttonStyle(CustomButtonStyle())
                
                Text("Current Identities:")
                Text(currentIdentityMap?.jsonString ?? "")
                    .fixedSize(horizontal: false, vertical: true)
                
                Button(action: {
                    let updatedIdentities = IdentityMap()
                    updatedIdentities.add(item: IdentityItem(id: "test-id"), withNamespace: "test-namespace")
                    Identity.updateIdentities(with: updatedIdentities)
                }) {
                    Text("Update Identities with test-namespace")
                }.buttonStyle(CustomButtonStyle())
                
                Button(action: {
                    Identity.removeIdentity(item: IdentityItem(id: "test-id"), withNamespace: "test-namespace")
                }) {
                    Text("Remove Identities with test-namespace")
                }.buttonStyle(CustomButtonStyle())
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Advertising Identifier:")
                    Button(action: {
                        updateUsingTrackingAuthorization()
                    }) {
                        Text("Request Tracking Authorization")
                    }.buttonStyle(CustomButtonStyle())
                    Text(trackingAuthorizationResultText)
                    Text("\(adID?.uuidString ?? "")")
                    
                    HStack {
                        Button(action: {
                            MobileCore.setAdvertisingIdentifier(adIdText)
                        }) {
                            Text("Set AdId")
                        }.buttonStyle(CustomButtonStyle())
                        TextField("Enter Ad ID", text: $adIdText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .fixedSize()
                            .autocapitalization(.none)
                    }
                    
                    HStack {
                        Button(action: {
                            MobileCore.setAdvertisingIdentifier(nil)
                        }) {
                            Text("Set AdId as nil")
                        }.buttonStyle(CustomButtonStyle())
                        Button(action: {
                            MobileCore.setAdvertisingIdentifier("00000000-0000-0000-0000-000000000000")
                        }) {
                            Text("Set AdId as zeros")
                        }.buttonStyle(CustomButtonStyle())
                    }
                }.padding()
            }
        }
    }
}

struct EdgeIdentityView_Previews: PreviewProvider {
    static var previews: some View {
        EdgeIdentityView()
    }
}

extension IdentityMap {
    var jsonString: String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let data = try? encoder.encode(self) else { return nil }
        
        return String(data: data, encoding: .utf8)
    }
}

