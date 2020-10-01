/*
 Copyright 2020 Adobe
 All Rights Reserved.
 
 NOTICE: Adobe permits you to use, modify, and distribute this file in
 accordance with the terms of the Adobe license agreement accompanying
 it.
 */

import UIKit
import SwiftUI
// step-assurance-start
import ACPGriffon
// step-assurance-end

class GriffonViewController: UIHostingController<GriffonView> {}

struct GriffonView: View {
    @State private var griffonSessionUrl = ""
    
    var body: some View {
        VStack(alignment: HorizontalAlignment.leading, spacing: 12) {
            TextField("Copy Assurance Session URL to here", text: $griffonSessionUrl)
            HStack {
                Button(action: {
                    // step-assurance-start
                    // replace the url with the valid one generated on Griffon UI
                    let url = URL(string: self.griffonSessionUrl)!
                    ACPGriffon.startSession(url)
                    // step-assurance-end
                }){
                    Text("Connect")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .font(.caption)
                }.cornerRadius(5)
            }
        }.padding()
    }
}
