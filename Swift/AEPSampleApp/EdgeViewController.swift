/*
 Copyright 2020 Adobe
 All Rights Reserved.
 
 NOTICE: Adobe permits you to use, modify, and distribute this file in
 accordance with the terms of the Adobe license agreement accompanying
 it.
 */

import UIKit
import SwiftUI
//step-edge-start
import AEPEdge
//step-edge-end

class EdgeViewController: UIHostingController<EdgeView> {}

struct EdgeView: View {
    /// Index of the product selected from the Picker. Index can be used to retrieve the `ProductItem` from the `products` array.
    @State private var productIndex = 0
    
    @State private var showAddToCartMessage = false
    @State private var showPurchaseMessage = false
    @State private var showProductReviewMessage = false
    
    /// Product review string
    @State private var reviewText: String = ""
    
    /// Email address as string,  used as the product reviewer identifier
    @State private var reviewerEmail: String = ""
    
    /// Product rating as integer from 1 to 5
    @State private var reviewRating: Int = 5
    
    /// Sample list of products. Use the `productIndex` to retrive the selected `ProductItem`
    private var products = [
        ProductItem(sku: "SHOES123", name: "Red canvas shoes", price: 34.76, currencyCode: "USD"),
        ProductItem(sku: "SHOES456", name: "Brown leather shoes", price: 52.81, currencyCode: "USD"),
        ProductItem(sku: "HAT567", name: "Wool Hat", price: 25.15, currencyCode: "USD"),
        ProductItem(sku: "HAT089", name: "Straw Hat", price: 11.85, currencyCode: "USD")
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                // Commerce section
                productSelectionSection
                commerceExampleSection
                Spacer()
                reviewExampleSection
            }.padding()
            Divider()
        }
    }
    
    /// UI picker to select a product item
    var productSelectionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Select a Product").bold()
            Picker(selection: $productIndex, label: Text("Select product.")) {
                ForEach(0..<products.count) {
                    Text(self.products[$0].name).font(.headline)
                }
            }
            .labelsHidden()
            .frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity, minHeight: 50, idealHeight: 50, maxHeight: 100, alignment: .center)
            .clipped()
        }
    }
    
    /// UI elements for the commerce example
    var commerceExampleSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("XDM Commerce Example").bold()
            
            HStack {
                Button(action: {
                    self.sendAddToCartXDMEvent()
                }){
                    HStack {
                        Image(systemName: "cart")
                            .font(.caption)
                        Text("Add to cart")
                            .font(.caption)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(5)
                }
            }
            .alert(isPresented: $showAddToCartMessage) {
                        Alert(title: Text("Add to cart"), message: Text("Your cart has been updated."), dismissButton: .default(Text("OK")))
                    }
            
            
            HStack {
                Button(action: {
                    self.sendPurchaseXDMEvent()
                }){
                    HStack {
                        Image(systemName: "bag")
                            .font(.caption)
                        Text("Purchase")
                            .font(.caption)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(5)
                }
            }
            .alert(isPresented: $showPurchaseMessage) {
                        Alert(title: Text("Purchase"), message: Text("Thank you for your purchase!"), dismissButton: .default(Text("OK")))
                    }
        }
        
    }
    
    /// UI elements for the product review example
    var reviewExampleSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("XDM Product Review Example").bold()
            
            TextField("Reviewer email", text: $reviewerEmail)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
            
            HStack {
                Text("Rating:")
                Picker(selection: $reviewRating, label: Text("Rating")) {
                    Text("Rubbish").tag(1).font(.headline)
                    Text("Okay").tag(2).font(.headline)
                    Text("Good").tag(3).font(.headline)
                    Text("Great").tag(4).font(.headline)
                    Text("Fantastic!").tag(5).font(.headline)
                }
                .labelsHidden()
                .frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity, minHeight: 50, idealHeight: 50, maxHeight: 100, alignment: .center)
                .clipped()
            }
                        
            TextField("Write review here.", text: $reviewText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                
            Button(action: {
                self.sendProductReviewXDMEvent()
            }){
                HStack {
                    Image(systemName: "cart")
                        .font(.caption)
                    Text("Submit Review")
                        .font(.caption)
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .background(Color.gray)
                .foregroundColor(.white)
                .cornerRadius(5)
            }
            
            .alert(isPresented: $showProductReviewMessage) {
                    Alert(title: Text("Product Review"), message: Text("Your product review was submitted."), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    /// Creates and sends an add to cart commerce event to the Adobe Experience Edge.
    func sendAddToCartXDMEvent() {
        print("Sending XDM commerce cart add event")
        // Get the selected ProductItem from the picker
        let productItem = products[productIndex]
        
        /// Create list with the purchased items
        var product1 = ProductListItemsItem()
        product1.name = productItem.name
        product1.priceTotal = productItem.price
        product1.sKU = productItem.sku
        product1.quantity = 1
        product1.currencyCode = productItem.currencyCode
        
        let productListItems: [ProductListItemsItem] = [product1]
        
        var productAdd = ProductListAdds()
        productAdd.value = 1

        /// Create Commerce object and add ProductListAdds details
        var commerce = Commerce()
        commerce.productListAdds = productAdd
        
        // Compose the XDM Schema object and set the event name
        var xdmData = MobileSDKCommerceSchema()
        xdmData.eventType = "commerce.productListAdds"
        xdmData.commerce = commerce
        xdmData.productListItems = productListItems

        // Create an Experience Event with the built schema and send it using the Platform extension

        //step-edge-start
        let event = ExperienceEvent(xdm: xdmData)
        Edge.sendEvent(experienceEvent: event)
        //step-edge-end
        
        self.showAddToCartMessage = true // remove this line when this method is fully implemented
    }
    
    /// Creates and sends a cart purchase event to the Adobe Experience Edge.
    func sendPurchaseXDMEvent() {
        print("Sending XDM commerce purchase event")
        // Get the selected ProductItem from the picker
        let productItem = products[productIndex]
        
        /// Create list with the purchased items
        var product1 = ProductListItemsItem()
        product1.name = productItem.name
        product1.priceTotal = productItem.price
        product1.sKU = productItem.sku
        product1.quantity = 1
        product1.currencyCode = productItem.currencyCode
        
        let purchasedItems: [ProductListItemsItem] = [product1]
        
        var orderTotal: Double = 0
        for item in purchasedItems {
            if let price = item.priceTotal {
                orderTotal += price
            }
        }
        /// Create PaymentItem which details the method of payment
        var paymentsItem = PaymentsItem()
        paymentsItem.paymentAmount = orderTotal
        paymentsItem.paymentType = "Credit card"
        
        /// Set the Order information
        var order = Order()
        order.priceTotal = orderTotal
        order.payments = [paymentsItem]
        order.currencyCode = "USD"

        /// Create Purchases action
        var purchases = Purchases()
        purchases.value = 1

        /// Create Commerce object and add Purchases action and Order details
        var commerce = Commerce()
        commerce.order = order
        commerce.purchases = purchases
        
        // Compose the XDM Schema object and set the event name
        var xdmData = MobileSDKCommerceSchema()
        xdmData.eventType = "commerce.purchases"
        xdmData.commerce = commerce
        xdmData.productListItems = purchasedItems

        // Create an Experience Event with the built schema and send it using the Platform extension

        //step-edge-start
        let event = ExperienceEvent(xdm: xdmData)
        Edge.sendEvent(experienceEvent: event)
        //step-edge-end
        
        self.showPurchaseMessage = true
    }
    
    /// Build a review event using a standard Dictionary datatype and send to the Adobe Experience Edge.
    /// Remember to tell Edge where the data should land by overriding the dataset ID
    func sendProductReviewXDMEvent() {
        print("Sending XDM product review event")

        // TODO - Assignment 3
        
        self.showProductReviewMessage = true
    }
    
}

struct EdgeViewController_Previews: PreviewProvider {
    static var previews: some View {
        EdgeView()
    }
}

/// Simple structure for a product item
struct ProductItem {
    let sku: String
    let name: String
    let price: Double
    let currencyCode: String
}
