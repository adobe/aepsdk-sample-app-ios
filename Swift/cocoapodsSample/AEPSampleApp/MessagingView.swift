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
    @State private var ecidState:String = ""

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
            Text("Messaging SDK setup is complete with ECID")
            Text(ecidState)
            Text("For more details please take a look at the documentation in the github repository.").bold()
        }.onAppear() {
            updateEcid()
        }
    }

    func updateEcid() {
        Identity.getExperienceCloudId { (ecid, err) in
            if ecid == nil {return}
            ecidState = ecid ?? ""
        }
    }
}
