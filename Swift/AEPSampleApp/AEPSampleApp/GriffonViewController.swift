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

class GriffonViewController: UIHostingController<GriffonView> {}

struct GriffonView: View {
    @State private var griffonSessionUrl = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            TextField("Griffon Session URL:", text: $griffonSessionUrl)
            HStack {
                Button(action: {
                    //ACPGriffon.startSession($griffonSessionUrl)
                }){
                    Text("Connect")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .font(.caption)
                }
                Button(action: {
                    //ACPGriffon.endSession()
                }) {
                    Text("Disconnect")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .font(.caption)
                }
            }
        Spacer()
        }.padding()
    }
}
