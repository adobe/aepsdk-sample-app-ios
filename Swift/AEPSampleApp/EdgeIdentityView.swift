/*
 Copyright 2021 Adobe
 All Rights Reserved.
 
 NOTICE: Adobe permits you to use, modify, and distribute this file in
 accordance with the terms of the Adobe license agreement accompanying
 it.
 */

import AdSupport
import AEPCore
import AEPEdgeIdentity
import AppTrackingTransparency
import Foundation
import SwiftUI

struct EdgeIdentityView: View {
    @State var currentEcid = ""
    @State var currentIdentityMap: IdentityMap?
    @State var adID: UUID?
    @State var adIdText: String = ""
    @State var trackingAuthorizationResultText: String = ""
    
    /// Provides the `advertisingIdentifier` for the given environment, assuming tracking authorization is provided
    ///
    /// Simulators will never provide a valid UUID, regardless of authorization; use the set ad ID flow to test a specific ad ID.
    func getAdvertisingIdentifierForEnvironment() -> UUID {
        #if targetEnvironment(simulator)
        print("""
            Simulator environment detected. Please note that simulators cannot retrieve valid advertising identifier
            from the ASIdentifierManager (as specified by Apple); an all-zeros UUID will be retrieved even if
            authorization is provided. If you want to use a specific ad ID, you can use the set ad ID flow.
            """)
        #endif
        print("Advertising identifier: \(ASIdentifierManager.shared().advertisingIdentifier)")
        return ASIdentifierManager.shared().advertisingIdentifier
    }
    
    /// Requests tracking authorization from the user; prompt will only be shown once per app install, as per Apple rules
    ///
    /// It is possible to change tracking permissions at the Settings app level. Any change in tracking permissions will terminate the app.
    /// It is also possible for system-wide tracking to be off but individual per-app permissions granted.
    /// If "Allow Apps to Request to Track" at the system level was on and is turned off, a system prompt appears asking if previously provided individual per-app tracking permissions should be kept as-is or all turned off
    func requestTrackingAuthorization() {
        // ATTrackingManager only available in iOS 14+
        // Requires Xcode 12 and AppTrackingTransparency framework
        if #available(iOS 14, *) {
            print("Calling requestTrackingAuthorization. Dialog will only be shown once per app install.")
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                // Tracking authorization dialog was shown and authorization given
                case .authorized:
                    trackingAuthorizationResultText = "Authorized"
                    // IDFA now accessible
                    self.adID = getAdvertisingIdentifierForEnvironment()
                    
                    // Set IDFA using Core API, which will be routed to Edge Identity extension.
                    // Note that this will automatically update ad ID consent (consent event dispatched)
                    // to "y" but only if the ad ID is not nil, all-zeros, or ""; in the case of the simulator it will be all-zeros.
                    // Set the ad ID manually after getting authorization to get consent updated properly
                    MobileCore.setAdvertisingIdentifier(self.adID?.uuidString)
                    
                // Tracking authorization dialog was shown and permission is denied
                case .denied:
                    trackingAuthorizationResultText = "Denied"
                    MobileCore.setAdvertisingIdentifier("")
                // Tracking authorization dialog has not been shown
                case .notDetermined:
                    trackingAuthorizationResultText = "Not Determined"
                // Tracking authorization dialog is not allowed to be shown
                case .restricted:
                    trackingAuthorizationResultText = "Restricted"
                @unknown default:
                    trackingAuthorizationResultText = "Unknown"
                }
                print("Request tracking authorization status is '\(trackingAuthorizationResultText)'.")
            }
        } else {
            // ASIdentifierManager used for iOS <= 13
            print("""
                  iOS version <= 13 detected. ATTrackingManager's requestTrackingAuthorization is not available; using ASIdentifierManager and getting IDFA directly.
                  ASIdentifierManager.shared().isAdvertisingTrackingEnabled: \(ASIdentifierManager.shared().isAdvertisingTrackingEnabled)
                  Advertising identifier: \(getAdvertisingIdentifierForEnvironment())
                  """)
            if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
                self.adID = getAdvertisingIdentifierForEnvironment()
                trackingAuthorizationResultText = "Tracking enabled"
                
                MobileCore.setAdvertisingIdentifier(self.adID?.uuidString)
                
            } else {
                trackingAuthorizationResultText = "Tracking disabled"
                
                MobileCore.setAdvertisingIdentifier("")
            }
            print("Tracking authorization status is '\(trackingAuthorizationResultText)'.")
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
            }.padding()

            VStack(alignment: .leading, spacing: 12) {
                Text("Advertising Identifier:")
                Button(action: {
                    requestTrackingAuthorization()
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

