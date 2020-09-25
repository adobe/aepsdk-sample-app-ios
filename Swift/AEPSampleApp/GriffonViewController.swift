/*
 Copyright 2020 Adobe
 All Rights Reserved.
 
 NOTICE: Adobe permits you to use, modify, and distribute this file in
 accordance with the terms of the Adobe license agreement accompanying
 it.
 */

import UIKit
import SwiftUI
import ACPGriffon

class GriffonViewController: UIHostingController<GriffonView> {}

struct GriffonView: View {
    @State private var griffonSessionUrl = ""
    
    var body: some View {
        VStack(alignment: HorizontalAlignment.leading, spacing: 12) {
            TextField("Griffon Session URL:", text: $griffonSessionUrl)
            HStack {
                Button(action: {
                    // replace the url with the valid one generated on Griffon UI
                    let url = URL(string: "testurl://test")!
                    ACPGriffon.startSession(url)
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
