/*
 Copyright 2022 Adobe
 All Rights Reserved.
 
 NOTICE: Adobe permits you to use, modify, and distribute this file in
 accordance with the terms of the Adobe license agreement accompanying
 it.
 */

import AEPOptimize
import SwiftUI
import WebKit

struct OptimizeView: View {
    @State private var viewDidLoad = false
    
    @State private var odSettings = OdSettings()
    @State private var targetSettings = TargetSettings()
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @ObservedObject private var propositions = Propositions()
    @ObservedObject private var imageLoader = ImageLoader()
    
    var body: some View {
        VStack {
            List {
                Section(header: Text("Text Offers")) {
                    if let textProposition = propositions.textProposition,
                       !textProposition.offers.isEmpty {
                        ForEach(textProposition.offers, id: \.self) { offer in
                            Text(offer.content)
                                .multilineTextAlignment(.center)
                                .frame(height: 120)
                                .frame(maxWidth: .infinity)
                                .onAppear {
                                    offer.displayed()
                                }
                                .onTapGesture {
                                    offer.tapped()
                                }
                        }
                    } else {
                        Text("Placeholder Text")
                            .multilineTextAlignment(.center)
                            .frame(height: 120)
                            .frame(maxWidth: .infinity)
                    }
                }
                
                Section(header: Text("Image Offers")) {
                    if let imageProposition = propositions.imageProposition,
                       !imageProposition.offers.isEmpty {
                        ForEach(imageProposition.offers, id: \.self) { offer in
                            Image(uiImage: imageLoader.uiImage ?? UIImage())
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 120)
                                .frame(maxWidth: .infinity)
                                .onAppear {
                                    imageLoader.updateImage(urlString: offer.content)
                                    offer.displayed()
                                }
                                .onTapGesture {
                                    offer.tapped()
                                }
                        }
                    } else {
                        Image(uiImage: imageLoader.uiImage ?? UIImage())
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 120)
                            .frame(maxWidth: .infinity)
                            .onAppear() {
                                imageLoader.updateImage(urlString: "https://gblobscdn.gitbook.com/spaces%2F-Lf1Mc1caFdNCK_mBwhe%2Favatar-1585843848509.png?alt=media")
                            }
                    }
                }
                
                Section(header: Text("Html Offers")) {
                    if let htmlProposition = propositions.htmlProposition,
                       !htmlProposition.offers.isEmpty {
                        ForEach(htmlProposition.offers, id: \.self) { offer in
                            WebView(htmlString: offer.content)
                                .multilineTextAlignment(.center)
                                .frame(height: 120)
                                .frame(maxWidth: .infinity)
                                .onAppear {
                                    offer.displayed()
                                }
                                .onTapGesture {
                                    offer.tapped()
                                }
                        }
                    } else {
                        WebView(htmlString:
                                        """
                                        <html><body><p style="color:green; font-size:50px;position: absolute;top: 40%;left: 50%;margin-right: -50%;transform: translate(-50%, -50%)">Placeholder Html</p></body></html>
                                        """)
                            .multilineTextAlignment(.center)
                            .frame(height: 120)
                            .frame(maxWidth: .infinity)
                    }
                }
                
                Section(header: Text("Json Offers")) {
                    if let jsonProposition = propositions.jsonProposition,
                       !jsonProposition.offers.isEmpty {
                        ForEach(jsonProposition.offers, id: \.self) { offer in
                            Text(offer.content)
                                .multilineTextAlignment(.center)
                                .frame(height: 120)
                                .frame(maxWidth: .infinity)
                                .onAppear {
                                    offer.displayed()
                                }
                                .onTapGesture {
                                    offer.tapped()
                                }
                        }
                    } else {
                        Text("""
                            { "placeholder": true }
                        """)
                            .multilineTextAlignment(.center)
                            .frame(height: 120)
                            .frame(maxWidth: .infinity)
                    }
                }
                
                Section(header: Text("Target Offers")) {
                    if let targetProposition = propositions.targetProposition,
                       !targetProposition.offers.isEmpty {
                        ForEach(targetProposition.offers, id: \.self) { offer in
                            if offer.type == OfferType.html {
                                WebView(htmlString: offer.content)
                                    .multilineTextAlignment(.center)
                                    .frame(height: 120)
                                    .frame(maxWidth: .infinity)
                                    .onAppear {
                                        offer.displayed()
                                    }
                                    .onTapGesture {
                                        offer.tapped()
                                    }
                            } else {
                                Text(offer.content)
                                    .multilineTextAlignment(.center)
                                    .frame(height: 120)
                                    .frame(maxWidth: .infinity)
                                    .onAppear {
                                        offer.displayed()
                                    }
                                    .onTapGesture {
                                        offer.tapped()
                                    }
                            }
                        }
                    } else {
                        Text("Placeholder Target Text")
                            .multilineTextAlignment(.center)
                            .frame(height: 120)
                            .frame(maxWidth: .infinity)
                    }
                }

            }
            Divider()
            HStack() {
                Button(action: {
                    let textDecisionScope = DecisionScope(name: odSettings.textEncodedDecisionScope)
                    let imageDecisionScope = DecisionScope(name: odSettings.imageEncodedDecisionScope)
                    let htmlDecisionScope = DecisionScope(name: odSettings.htmlEncodedDecisionScope)
                    let jsonDecisionScope = DecisionScope(name: odSettings.jsonEncodedDecisionScope)
                    let targetScope = DecisionScope(name: targetSettings.targetMbox)

                    Optimize.updatePropositions(for: [
                        textDecisionScope,
                        imageDecisionScope,
                        htmlDecisionScope,
                        jsonDecisionScope,
                        targetScope
                    ], withXdm: nil,
                       andData: nil)
                    
                }) {
                    Text("Update Propositions")
                }
                .buttonStyle(CustomButtonStyle())
                .frame(maxWidth: 110)
                
                Button(action: {
                    let textDecisionScope = DecisionScope(name: odSettings.textEncodedDecisionScope)
                    let imageDecisionScope = DecisionScope(name: odSettings.imageEncodedDecisionScope)
                    let htmlDecisionScope = DecisionScope(name: odSettings.htmlEncodedDecisionScope)
                    let jsonDecisionScope = DecisionScope(name: odSettings.jsonEncodedDecisionScope)
                    let targetScope = DecisionScope(name: targetSettings.targetMbox)
    
                    Optimize.getPropositions(for: [
                        textDecisionScope,
                        imageDecisionScope,
                        htmlDecisionScope,
                        jsonDecisionScope,
                        targetScope
                    ]) {
                            propositionsDict, error in
    
                            if let error = error {
                                showAlert = true
                                alertMessage = error.localizedDescription
                            } else {
                                
                                guard let propositionsDict = propositionsDict else {
                                    return
                                }
                                
                                DispatchQueue.main.async {
                                    
                                    if propositionsDict.isEmpty {
                                        propositions.textProposition = nil
                                        propositions.imageProposition = nil
                                        propositions.htmlProposition = nil
                                        propositions.jsonProposition = nil
                                        propositions.targetProposition = nil
                                        return
                                    }
                                    
                                    if let textProposition = propositionsDict[textDecisionScope] {
                                        propositions.textProposition = textProposition
                                    }

                                    if let imageProposition = propositionsDict[imageDecisionScope] {
                                        propositions.imageProposition = imageProposition
                                    }

                                    if let htmlProposition = propositionsDict[htmlDecisionScope] {
                                        propositions.htmlProposition = htmlProposition
                                    }
                                    
                                    if let jsonProposition = propositionsDict[jsonDecisionScope] {
                                        propositions.jsonProposition = jsonProposition
                                    }
                                    
                                    if let targetProposition = propositionsDict[targetScope] {
                                        propositions.targetProposition = targetProposition
                                    }
                                }
                            }
                    }
                }) {
                    Text("Get Propositions")
                }
                .buttonStyle(CustomButtonStyle())
                .frame(maxWidth: 110)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Error: Get Propositions"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                
                Button(action: {
                    Optimize.clearCachedPropositions()
                }) {
                    Text("Clear Propositions")
                }
                .buttonStyle(CustomButtonStyle())
                .frame(maxWidth: 110)
            }
        }
        .onAppear {
            if viewDidLoad == false {
                viewDidLoad = true

                Optimize.onPropositionsUpdate { propositionsDict in
                    
                    DispatchQueue.main.async {
                        if let textProposition = propositionsDict[DecisionScope(name: self.odSettings.textEncodedDecisionScope)] {
                            self.propositions.textProposition = textProposition
                        }
                        if let imageProposition = propositionsDict[DecisionScope(name: self.odSettings.imageEncodedDecisionScope)] {
                            self.propositions.imageProposition = imageProposition
                        }
                        if let htmlProposition = propositionsDict[DecisionScope(name: self.odSettings.htmlEncodedDecisionScope)] {
                            self.propositions.htmlProposition = htmlProposition
                        }
                        if let jsonProposition = propositionsDict[DecisionScope(name: self.odSettings.jsonEncodedDecisionScope)] {
                            self.propositions.jsonProposition = jsonProposition
                        }
                        if let targetProposition = propositionsDict[DecisionScope(name: self.targetSettings.targetMbox)] {
                            self.propositions.targetProposition = targetProposition
                        }
                    }
                }
            }
        }
    }
}


struct OdSettings {
    var textEncodedDecisionScope: String = ""
    var imageEncodedDecisionScope: String = ""
    var htmlEncodedDecisionScope: String = ""
    var jsonEncodedDecisionScope: String = ""
}

struct TargetSettings {
    var targetMbox: String = ""
    var mboxParameters: [String: String] = [:]
    var profileParameters: [String: String] = [:]
    var order: TargetOrder = TargetOrder(orderId: "", orderTotal: "", purchasedProductIds: "")
    var product: TargetProduct = TargetProduct(productId: "", categoryId: "")
}

struct TargetOrder {
    var orderId: String
    var orderTotal: String
    var purchasedProductIds: String
    
    func isValid() -> Bool {
        return !orderId.isEmpty && (!orderTotal.isEmpty && Double(orderTotal) != nil) && !purchasedProductIds.isEmpty
    }
}

struct TargetProduct {
    var productId: String
    var categoryId: String
    
    func isValid() -> Bool {
        return !productId.isEmpty && !categoryId.isEmpty
    }
}

class Propositions: ObservableObject {
    @Published var textProposition: Proposition?
    @Published var imageProposition: Proposition?
    @Published var htmlProposition: Proposition?
    @Published var jsonProposition: Proposition?
    @Published var targetProposition: Proposition?
    
    init() {
        textProposition = nil
        imageProposition = nil
        htmlProposition = nil
        jsonProposition = nil
        targetProposition = nil
    }
}

struct WebView: UIViewRepresentable {
    var htmlString: String
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(self.htmlString, baseURL: nil)
    }
}

class ImageLoader: ObservableObject {
    @Published var uiImage: UIImage? = nil

    init() {}

    func updateImage(urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            
            DispatchQueue.main.async {
                self.objectWillChange.send()
                self.uiImage = UIImage(data: data)
            }
        }
        .resume()
    }
}


struct OptimizeView_Previews: PreviewProvider {
    static var previews: some View {
        OptimizeView()
    }
}
