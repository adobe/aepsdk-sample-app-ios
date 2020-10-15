/*
 Copyright 2020 Adobe
 All Rights Reserved.
 
 NOTICE: Adobe permits you to use, modify, and distribute this file in
 accordance with the terms of the Adobe license agreement accompanying
 it.
 */

import UIKit
import SwiftUI
import AEPEdge

class EdgeViewController: UIHostingController<EdgeView> {}

struct EdgeView: View {
    @State private var showAddToCartNotImplemented = false
    @State private var showPurchaseMessage = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                // Commerce section
                commerceExampleSection
            }.padding()
            Divider()
        }
    }
    
    var commerceExampleSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("XDM Commerce Example").bold()
            
            HStack {
                Button(action: {
                    sendAddToCartXDMEvent()
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
            .alert(isPresented: $showAddToCartNotImplemented) {
                        Alert(title: Text("Add to cart"), message: Text("This method is not implemented yet"), dismissButton: .default(Text("OK")))
                    }
            
            
            HStack {
                Button(action: {
                    sendPurchaseXDMEvent()
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
    
    /// Creates and sends an add to cart commerce event to the Adobe Experience Edge.
    func sendAddToCartXDMEvent() {
        // TODO: to be implemented
        self.showAddToCartNotImplemented = true // remove this line when this method is fully implemented
    }
    
    /// Creates and sends a cart purchase event to the Adobe Experience Edge.
    func sendPurchaseXDMEvent() {
        print("Sending XDM commerce purchase event")
        
        /// Create list with the purchased items
        var product1 = ProductListItemsItem()
        product1.name = "Shoes"
        product1.priceTotal = 34.76
        product1.sKU = "SHOES123"
        product1.quantity = 1
        product1.currencyCode = "USD"
        
        var product2 = ProductListItemsItem()
        product2.name = "Hat"
        product2.priceTotal = 30.6
        product2.sKU = "HAT567"
        product2.quantity = 2
        product2.currencyCode = "USD"
        let purchasedItems: [ProductListItemsItem] = [product1, product2]
        
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
        let event = ExperienceEvent(xdm: xdmData)
        Edge.sendEvent(experienceEvent: event)
        
        self.showPurchaseMessage = true
    }
}

struct EdgeViewController_Previews: PreviewProvider {
    static var previews: some View {
        EdgeView()
    }
}
