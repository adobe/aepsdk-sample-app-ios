/*
 Copyright 2021 Adobe
 All Rights Reserved.
 
 NOTICE: Adobe permits you to use, modify, and distribute this file in
 accordance with the terms of the Adobe license agreement accompanying
 it.
 */

import Foundation
import AEPCore
import AEPEdgeConsent
import SwiftUI

struct ConsentView: View {
    @State var currentConsents = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Button("Set Collect Consent - Yes") {
                    let collectConsent = ["collect": ["val": "y"]]
                    let currentConsents = ["consents": collectConsent]
                    Consent.update(with: currentConsents)
                }.buttonStyle(CustomButtonStyle())
                
                Button("Set Collect Consent - No") {
                    let collectConsent = ["collect": ["val": "n"]]
                    let currentConsents = ["consents": collectConsent]
                    Consent.update(with: currentConsents)
                }.buttonStyle(CustomButtonStyle())
                
                Button("Set default collect consent = y") {
                    let defaultsConsents = ["collect": ["val": "y"]]
                    let defaultConsent = ["consent.default": ["consents": defaultsConsents]]
                    MobileCore.updateConfigurationWith(configDict: defaultConsent)
                }.buttonStyle(CustomButtonStyle())
                
                Button("Get Consents") {
                    Consent.getConsents { consents, error in
                        guard error == nil, let consents = consents else { return }
                        guard let jsonData = try? JSONSerialization.data(withJSONObject: consents, options: .prettyPrinted) else { return }
                        guard let jsonStr = String(data: jsonData, encoding: .utf8) else { return }
                        currentConsents = jsonStr
                    }
                }.buttonStyle(CustomButtonStyle())
                
                Text("Current Consents:")
                Text(currentConsents)
                    .fixedSize(horizontal: false, vertical: true)
            }.padding()
        }
    }
}

struct ConsentView_Previews: PreviewProvider {
    static var previews: some View {
        ConsentView()
    }
}
