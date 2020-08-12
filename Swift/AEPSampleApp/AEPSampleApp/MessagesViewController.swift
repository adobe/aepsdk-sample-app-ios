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

class MessagesViewController: UIHostingController<MessagesView>{}

struct MessagesView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("In-App Messages in Different Layouts").bold()
            HStack {
                Button(action: {
                    //                let eventName = "fullMessage"
                    //                let additionalContextData = ["campaign": "fullMessage"]
                    //                ACPCore.trackAction(eventName, data: additionalContextData)
                }){
                    Text("Full Screen")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .font(.caption)
                }.cornerRadius(5)
                Button(action: {
                    //                let eventName = "alertMessage"
                    //                let additionalContextData = ["campaign": "alertMessage"]
                    //                ACPCore.trackAction(eventName, data: additionalContextData)
                }) {
                    Text("Alert")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .font(.caption)
                }.cornerRadius(5)
            }
            HStack {
                Button(action: {
                    //                let eventName = "largeModalMessage"
                    //                let additionalContextData = ["campaign": "largeModalMessage"]
                    //                ACPCore.trackAction(eventName, data: additionalContextData)
                }){
                    Text("Large Modal")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .font(.caption)
                }.cornerRadius(5)
                Button(action: {
                    //                let eventName = "smallModalMessage"
                    //                let additionalContextData = ["campaign": "smallModalMessage"]
                    //                ACPCore.trackAction(eventName, data: additionalContextData)
                }) {
                    Text("Small Modal")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .font(.caption)
                }.cornerRadius(5)
            }
            
            Button(action: {
                //            let eventName = "localNotificationMessage"
                //            let additionalContextData = ["campaign": "localNotificationMessage"]
                //            ACPCore.trackAction(eventName, data: additionalContextData)
            }) {
                Text("Local Notification")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .font(.caption)
            }.cornerRadius(5)
        }.padding()
    }
}

