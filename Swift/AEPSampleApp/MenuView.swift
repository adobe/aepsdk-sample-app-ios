/*
 Copyright 2021 Adobe
 All Rights Reserved.
 
 NOTICE: Adobe permits you to use, modify, and distribute this file in
 accordance with the terms of the Adobe license agreement accompanying
 it.
 */

import SwiftUI

struct MenuView: View {
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Core")) {
                    NavigationLink(destination: CoreView().navigationBarTitle("Core")) {
                        Text("Core")
                    }
                }
                
                Section(header: Text("Edge")) {
                    NavigationLink(destination: EdgeView().navigationBarTitle("Edge")) {
                        Text("Edge")
                    }
                    
                    NavigationLink(destination: ConsentView().navigationBarTitle("Consent")) {
                        Text("Consent")
                    }
                    
                    NavigationLink(destination: EdgeIdentityView().navigationBarTitle("Edge Identity")) {
                        Text("Edge Identity")
                    }
                }
                
                Section(header: Text("Validation")) {
                    NavigationLink(destination: AssuranceView().navigationBarTitle("Assurance")) {
                        Text("Assurance")
                    }
                }
                
                Section(header: Text("Messaging")) {
                    NavigationLink(destination: MessagingView().navigationBarTitle("Messaging")) {
                        Text("Messaging")
                    }
                }
                
                Section(header: Text("Optimize")) {
                    NavigationLink(destination: OptimizeView().navigationBarTitle("Optimize")) {
                        Text("Optimize")
                    }
                }
            }.navigationBarTitle(Text("Extensions"))
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
