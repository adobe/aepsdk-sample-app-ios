/*
 Copyright 2020 Adobe
 All Rights Reserved.
 
 NOTICE: Adobe permits you to use, modify, and distribute this file in
 accordance with the terms of the Adobe license agreement accompanying
 it.
 */

import UIKit
import SwiftUI

class GriffonViewController: UIHostingController<GriffonView> {}

struct GriffonView: View {
    @State private var griffonSessionUrl = ""
    
    var body: some View {
        VStack(alignment: HorizontalAlignment.leading, spacing: 12) {
            TextField("Copy Assurance Session URL to here", text: $griffonSessionUrl)
            HStack {
                Button(action: {
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
