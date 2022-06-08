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
    @State var urlVariablesText: String = ""
    
    /// Updates view for ad ID related elements
    func setDeviceAdvertisingIdentifier() {
        let isTrackingAuthorized = AdIdUtils.isTrackingAuthorized()
        print("isTrackingAuthorized: \(isTrackingAuthorized)")
        trackingAuthorizationResultText = isTrackingAuthorized ? "Tracking allowed" : "Tracking not allowed"
        
        if isTrackingAuthorized {
            self.adID = AdIdUtils.getAdvertisingIdentifierForEnvironment()
            print("Advertising identifier fetched: \(String(describing: adID))")
            MobileCore.setAdvertisingIdentifier(self.adID?.uuidString)
        }
        else {
            print("Ad tracking not authorized; setting ad ID to the empty string")
            MobileCore.setAdvertisingIdentifier("")
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Current ECID:")
                Button(action: {
                    Identity.getExperienceCloudId { ecid, error in
                        currentEcid = ecid ?? ""
                    }
                    
                }) {
                    
                    Text("Get ExperienceCloudId")
                }.buttonStyle(CustomButtonStyle())
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
                
                Text("Current Identities:")
                Button(action: {
                    Identity.getIdentities { identityMap, error in
                        currentIdentityMap = identityMap
                    }
                    
                }) {
                    Text("Get Identities")
                }.buttonStyle(CustomButtonStyle())
                
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
                        setDeviceAdvertisingIdentifier()
                    }) {
                        Text("Update ad ID with current IDFA")
                    }.buttonStyle(CustomButtonStyle())
                    Text(trackingAuthorizationResultText)
                    Text("\(adID?.uuidString ?? "")")
                    
                    HStack {
                        Button(action: {
                            MobileCore.setAdvertisingIdentifier(adIdText)
                        }) {
                            Text("Set ad ID")
                        }.buttonStyle(CustomButtonStyle())
                        TextField("Enter ad ID", text: $adIdText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .fixedSize()
                            .autocapitalization(.none)
                    }
                    
                    HStack {
                        Button(action: {
                            MobileCore.setAdvertisingIdentifier(nil)
                        }) {
                            Text("Set ad ID as nil")
                        }.buttonStyle(CustomButtonStyle())
                        Button(action: {
                            MobileCore.setAdvertisingIdentifier("00000000-0000-0000-0000-000000000000")
                        }) {
                            Text("Set ad ID as all-zeros")
                        }.buttonStyle(CustomButtonStyle())
                        Button(action: {
                            MobileCore.setAdvertisingIdentifier("")
                        }) {
                            Text("Set ad ID as empty string")
                        }.buttonStyle(CustomButtonStyle())
                    }
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    
                    Text("Get URLVariables:")
                    Button(action: {
                        self.urlVariablesText = ""

                        AEPEdgeIdentity.Identity.getUrlVariables { urlVariablesString, _ in
                            self.urlVariablesText = urlVariablesString ?? "URLVariables not generated"
                        }
                        
                    }) {
                        Text("Get URLVariables")
                    }.buttonStyle(CustomButtonStyle())
                    
                    Text(urlVariablesText)
                }
            }.padding()
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

