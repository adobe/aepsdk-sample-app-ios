/*
 Copyright 2021 Adobe
 All Rights Reserved.
 
 NOTICE: Adobe permits you to use, modify, and distribute this file in
 accordance with the terms of the Adobe license agreement accompanying
 it.
 */

import UIKit
import SwiftUI
import AEPCore
import AEPServices
import AEPTarget

struct TargetView: View {
    @State private var prefetchError = false
    @State private var prefetchErrorMessage: String = ""
    @State private var retrieveCallback = false
    @State private var retrievedContent: String = ""
    @State var updatedThirdPartyId: String = ""
    @State private var getThirdPartyIDCallback = false
    @State private var getThirdPartyIDResult: String = ""
    @State private var getTntIDCallback = false
    @State private var getTntIDResult: String = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                targetRequestSection
                identitySection
                previewSection
            }.padding()
        }
    }

    var targetRequestSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Target Requests").bold()
            Button(action: {
                Target.prefetchContent(
                    [
                        TargetPrefetch(name: "aep-loc-1", targetParameters: nil),
                        TargetPrefetch(name: "aep-loc-2", targetParameters: nil),
                    ]){ error in
                    if let error = error{
                        self.prefetchError = true
                        self.prefetchErrorMessage = String(describing: error)
                    }
                }
            }) {
                Text("Prefetch Locations")
            }.buttonStyle(CustomButtonStyle())
            .alert(isPresented: $prefetchError){
                Alert(title: Text("Prefetch Error"),message: Text(self.prefetchErrorMessage),dismissButton: .default(Text("Got it!")))
            }
            
            Button(action: {
                Target.clearPrefetchCache()
            }) {
                Text("Clear Prefetched Cache")
            }.buttonStyle(CustomButtonStyle())
            
            Button(action: {
                Target.retrieveLocationContent([TargetRequest(mboxName: "aep-loc-2", defaultContent: "DefaultValue", targetParameters: nil){ content in
                    self.retrieveCallback = true
                    self.retrievedContent = content ?? "null"
                }])
            }) {
                Text("Retrieve Location")
            }.buttonStyle(CustomButtonStyle())
            .alert(isPresented: $retrieveCallback){
                Alert(title: Text("Retrieved Content"),message: Text(self.retrievedContent),dismissButton: .default(Text("Got it!")))
            }
            
            Button(action: {
                Target.displayedLocations(["aep-loc-1", "aep-loc-2"], targetParameters: TargetParameters(parameters: ["mbox_parameter_key": "mbox_parameter_value"], profileParameters: ["name": "Smith"], order: TargetOrder(id: "id1", total: 1.0, purchasedProductIds: ["ppId1"]), product: TargetProduct(productId: "pId1", categoryId: "cId1")))
            }) {
                Text("Locations displayed")
            }.buttonStyle(CustomButtonStyle())
            
            Button(action: {
                Target.clickedLocation("aep-loc-1", targetParameters: TargetParameters(parameters: ["mbox_parameter_key": "mbox_parameter_value"], profileParameters: ["name": "Smith"], order: TargetOrder(id: "id1", total: 1.0, purchasedProductIds: ["ppId1"]), product: TargetProduct(productId: "pId1", categoryId: "cId1")))
            }) {
                Text("Location clicked")
            }.buttonStyle(CustomButtonStyle())
            
            
        }
    }
    
    var identitySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Target Identities").bold()
            Button(action: {
                Target.resetExperience()
            }) {
                Text("Reset Experience")
            }.buttonStyle(CustomButtonStyle())
            
            TextField("Please enter thirdPartyId", text: $updatedThirdPartyId).multilineTextAlignment(.center)
            
            Button(action: {
                Target.setThirdPartyId(updatedThirdPartyId)
            }) {
                Text("Set Third Party ID")
            }.buttonStyle(CustomButtonStyle())
            
            Button(action: {
                Target.getThirdPartyId{ id, error in
                    self.getThirdPartyIDCallback = true
                    if let error = error {
                        self.getThirdPartyIDResult = String(describing: error)
                    }
                    if let id = id {
                        self.getThirdPartyIDResult = "id = \(id)"
                    }
                }
            }) {
                Text("Get Third Party ID")
            }.buttonStyle(CustomButtonStyle())
            .alert(isPresented: $getThirdPartyIDCallback){
                Alert(title: Text("Third Party ID"),message: Text(self.getThirdPartyIDResult),dismissButton: .default(Text("Got it!")))
            }
            
            Button(action: {
                Target.getTntId{ id, error in
                    self.getTntIDCallback = true
                    if let error = error {
                        self.getTntIDResult = String(describing: error)
                    }
                    if let id = id {
                        self.getTntIDResult = "id = \(id)"
                    }
                }
            }) {
                Text("Get TNT ID")
            }.buttonStyle(CustomButtonStyle())
            .alert(isPresented: $getTntIDCallback){
                Alert(title: Text("TNT ID"),message: Text(self.getTntIDResult),dismissButton: .default(Text("Got it!")))
            }
            
        }
    }
    
    var previewSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Preview Mode").bold()
            Button(action: {
                MobileCore.updateConfigurationWith(configDict: ["target.previewEnabled": true])
                sleep(1)
                MobileCore.collectLaunchInfo(["adb_deeplink": "sampleapp://?at_preview_token=xxxxx"])
            }) {
                Text("Enter Preview")
            }.buttonStyle(CustomButtonStyle())
        }
    }
    
}

struct TargetViewController_Previews: PreviewProvider {
    static var previews: some View {
        TargetView()
    }
}
