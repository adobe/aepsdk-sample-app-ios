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

