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
import AEPEdge
import AEPIdentity
import AEPMessaging
import AEPServices

class MessagingViewController: UIHostingController<MessagingView> {}

struct MessagingView: View {
    @State private var personalEmail:String = ""

    let LOG_PREFIX = "MessagingViewController"

    var body: some View {
        VStack(alignment: HorizontalAlignment.leading, spacing: 12) {
            messaging
        }.padding().onAppear() {
            MobileCore.track(state: "Messaging", data:nil)
        }
    }

    /// UI elements for the product review example
    var messaging: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Give an email for personalization").bold()

            TextField("", text: $personalEmail)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)

            Button(action: {
                self.sendProfileData()
            }){
                HStack {
                    Text("Update Email on your AEPProfile")
                        .font(.caption)
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .background(Color.gray)
                .foregroundColor(.white)
                .cornerRadius(5)
            }
        }
    }

    func sendProfileData() {
        Identity.getExperienceCloudId { (ecid, err) in
            if ecid == nil {return}
            var xdmData : [String: Any] = [:]
            xdmData["identityMap"] = ["ECID" : [["id" : ecid]], "Email": [["id" : personalEmail]]]
            let experienceEvent = ExperienceEvent(xdm: xdmData, datasetIdentifier: AppDelegate.EMAIL_UPDATE_DATASET)
                        
            Edge.sendEvent(experienceEvent: experienceEvent) { (_: [EdgeEventHandle]) in
                Log.debug(label: LOG_PREFIX, "Edge call is complete")
            }
        }
    }
}
