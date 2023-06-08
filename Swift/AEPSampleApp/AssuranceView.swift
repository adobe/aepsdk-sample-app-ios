/*
 Copyright 2020 Adobe
 All Rights Reserved.
 
 NOTICE: Adobe permits you to use, modify, and distribute this file in
 accordance with the terms of the Adobe license agreement accompanying
 it.
 */

import UIKit
import SwiftUI
import AEPAssurance
import AEPCore

struct AssuranceView: View {
    @State private var assuranceSessionUrl:String = ""
    
    var body: some View {
        VStack(alignment: HorizontalAlignment.leading, spacing: 12) {
            TextField("Copy Assurance Session URL to here", text: $assuranceSessionUrl)
            HStack {
                Button(action: {
                    // replace the url with the valid one generated on Assurance UI
                    if let url = URL(string: self.assuranceSessionUrl) {
                        Assurance.startSession(url: url)
                    }
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
