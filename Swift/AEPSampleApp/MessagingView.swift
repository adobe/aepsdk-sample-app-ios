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
    @State private var personalisedData:String = ""

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
            Text("Enter the string matching your custom action in CJM").bold()

            TextField("CustomAction", text: $customEvent)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)

            Text("Give an email for personalization").bold()

            TextField("", text: $personalisedData)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)

            Button(action: {
                self.sendProfileData()
            }){
                HStack {
                    Text("Update Name in AEP profile")
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
            let payload = getPayload(ecid: ecid ?? "")
            guard let dccsUrl = URL(string: AppDelegate.PLATFORM_DCS_URL) else {
                        Log.warning(label: LOG_PREFIX, "DCCS endpoint is invalid. All requests to sync with profile will fail.")
                        return
                    }

            let headers = ["Content-Type": "application/json"]
            let request = NetworkRequest(url: dccsUrl,
                                                 httpMethod: .post,
                                                 connectPayload: payload,
                                                 httpHeaders: headers,
                                                 connectTimeout: 5.0,
                                                 readTimeout: 5.0)

            ServiceProvider.shared.networkService.connectAsync(networkRequest: request) { (connection: HttpConnection) in
                        if connection.error != nil {
                            Log.warning(label: LOG_PREFIX, "Error sending profile update \(String(describing: connection.error?.localizedDescription)).")
                        } else {
                            Log.trace(label: LOG_PREFIX, "Success in updating profile")
                        }
                    }
        }
    }

    func getPayload(ecid: String) -> String {
        let payload = "{\n" +
        "    \"header\" : {\n" +
            "        \"imsOrgId\": \"" + AppDelegate.ORG_ID + "\",\n" +
        "        \"source\": {\n" +
        "            \"name\": \"mobile\"\n" +
        "        },\n" +
        "         \"datasetId\" : \"%@\"\n" +
        "    },\n" +
        "    \"body\": {\n" +
        "        \"xdmEntity\": {\n" +
        "            \"identityMap\": {\n" +
        "                \"ECID\": [\n" +
        "                    {\n" +
        "                         \"id\" : \"%@\"\n" +
        "                    }\n" +
        "                ],\n" +
        "                \"Email\": [\n" +
        "                    {\n" +
        "                         \"id\" : \"%@\"\n" +
        "                    }\n" +
        "                ]\n" +
        "            },\n" +
        "      \"testProfile\": true,\n" +
        "         \"personalEmail\": {\n" +
        "          \"address\" : \"%@\"\n" +
        "       }\n" +
        "      }\n" +
        "   }\n" +
        "}"

        let postBodyString = String.init(format: payload, AppDelegate.CUSTOM_PROFILE_DATASET, ecid, personalisedData, personalisedData)
        return postBodyString
    }
}

struct MessagingViewController_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
