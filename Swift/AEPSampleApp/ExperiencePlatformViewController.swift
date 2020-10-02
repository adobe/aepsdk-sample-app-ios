/*
 Copyright 2020 Adobe
 All Rights Reserved.
 
 NOTICE: Adobe permits you to use, modify, and distribute this file in
 accordance with the terms of the Adobe license agreement accompanying
 it.
 */

import UIKit
import SwiftUI
import AEPExperiencePlatform

class ExperiencePlatformViewController: UIHostingController<ExperiencePlatformView> {}

struct ExperiencePlatformView: View {
    @State private var redSelected = false
    @State private var blueSelected = false
    @State private var orangeSelected = false
    @State private var greenSelected = false
    @State private var yellowSelected = false
    @State private var shoppingCart = ShoppingCart()
    
    let productDataLoader = ProductDataLoader()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                // Commerce section
                commerceExampleSection
            }.padding()
        }
    }
    
    var commerceExampleSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Commerce example").bold()
            Text("Select some colorful circles")
            HStack {
                Button(action: {
                    self.redSelected = !self.redSelected
                    if self.redSelected {
                        addToCart(color: "red")
                    } else {
                        removeFromCart(color: "red")
                    }
                }){
                    Circle()
                        .fill(self.redSelected ? Color.red : Color.gray)
                        .frame(width: 50.0, height: 50.0)
                }
                Button(action: {
                    self.blueSelected = !self.blueSelected
                    if self.blueSelected {
                        addToCart(color: "blue")
                    } else {
                        removeFromCart(color: "blue")
                    }
                }){
                    Circle()
                        .fill(self.blueSelected ? Color.blue : Color.gray)
                        .frame(width: 50.0, height: 50.0)
                }
                Button(action: {
                    self.orangeSelected = !self.orangeSelected
                    if self.orangeSelected {
                        addToCart(color: "orange")
                    } else {
                        removeFromCart(color: "orange")
                    }
                }){
                    Circle()
                        .fill(self.orangeSelected ? Color.orange : Color.gray)
                        .frame(width: 50.0, height: 50.0)
                }
                Button(action: {
                    self.greenSelected = !self.greenSelected
                    if self.greenSelected {
                        addToCart(color: "green")
                    } else {
                        removeFromCart(color: "green")
                    }
                }){
                    Circle()
                        .fill(self.greenSelected ? Color.green : Color.gray)
                        .frame(width: 50.0, height: 50.0)
                }
                Button(action: {
                    self.yellowSelected = !self.yellowSelected
                    if self.yellowSelected {
                        addToCart(color: "yellow")
                    } else {
                        removeFromCart(color: "yellow")
                    }
                }){
                    Circle()
                        .fill(self.yellowSelected ? Color.yellow : Color.gray)
                        .frame(width: 50.0, height: 50.0)
                }
                VStack(alignment: .leading, spacing: 12) {
                    Text("Total:")
                    Text(String(format: "$%.2f", shoppingCart.total))
                }
            }
            
            HStack {
                Button(action: {
                    sendPurchaseXdmEvent()
                    shoppingCart.clearCart()
                    resetState()
                    print("Colors purchased")
                }){
                    HStack {
                        Image(systemName: "cart")
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
        }
    }
    
    func resetState() {
        self.blueSelected = false
        self.redSelected = false
        self.orangeSelected = false
        self.greenSelected = false
        self.yellowSelected = false
    }
    
    func addToCart(color: String) {
        if var product = productDataLoader.findItem(withName: color) {
            product.quantity = 1
            shoppingCart.add(product: product)
            print("Color \(color) added to cart")
            sendAddToCartXDMEvent(color: color)
        } else {
            print("Color \(color) not found in the known products list")
        }
    }
    
    func removeFromCart(color: String) {
        if shoppingCart.remove(colorWithName: color) {
            sendRemoveFromCartXDMEvent(color: color)
            print("Color \(color) removed from cart")
        } else {
            print("Color \(color) not found in the cart")
        }
    }
    
    /// Creates and sends an add to cart commerce event to the Adobe Experience Edge.
    /// This method should be called when a product is selected (added to the cart).
    func sendAddToCartXDMEvent(color: String) {
        guard var product = productDataLoader.findItem(withName: color) else {
            print("Color \(color) not found in the known products list")
            return
        }
        
        product.quantity = 1
        
        // Mark this event as a productListAdds one
        var productListAdds = ProductListAdds()
        productListAdds.value = 1
        
        // Attach the product list added
        var commerce = Commerce()
        commerce.productListAdds = productListAdds
        
        // Compose the XDM Schema object and set the event name
        var xdmData = MobileSDKCommerceSchema()
        xdmData.eventType = Constants.AEP.COMMERCE_ADD_TO_CART_EVENT
        xdmData.commerce = commerce
        xdmData.productListItems = [product]
        
        // Create an Experience Event with the built schema and send it using the Platform extension
        let event = ExperiencePlatformEvent(xdm: xdmData)
        ExperiencePlatform.sendEvent(experiencePlatformEvent: event)
    }
    
    /// Creates and sends a remove from cart commerce event to the Adobe Experience Edge.
    /// This method should be called when a product is deselected (removed from the cart).
    func sendRemoveFromCartXDMEvent(color: String) {
        guard var product = productDataLoader.findItem(withName: color) else {
            print("Color \(color) not found in the known products list")
            return
        }
        
        product.quantity = 1
        
        // Mark this event as a productListRemovals one
        var productListRemovals = ProductListRemovals()
        productListRemovals.value = 1
        
        // Attach the products list removed
        var commerce = Commerce()
        commerce.productListRemovals = productListRemovals
        
        // Compose the XDM Schema object and set the event name
        var xdmData = MobileSDKCommerceSchema()
        xdmData.eventType = Constants.AEP.COMMERCE_REMOVED_FROM_CART_EVENT
        xdmData.commerce = commerce
        xdmData.productListItems = [product]
        
        // Create an Experience Event with the built schema and send it using the Platform extension
        let event = ExperiencePlatformEvent(xdm: xdmData)
        ExperiencePlatform.sendEvent(experiencePlatformEvent: event)
    }
    
    /// Creates and sends a cart purchase event to the Adobe Experience Edge.
    /// This method should be called when a final purchase is made for the shopping cart.
    func sendPurchaseXdmEvent() {
        guard !shoppingCart.items.isEmpty else {
            print("Cannot create purchase event because no items were found in cart.")
            return
        }
        
        print("Sending purchase XDM event")

        /// Create PaymentItem which details the method of payment
        var paymentsItem = PaymentsItem()
        paymentsItem.paymentAmount = shoppingCart.total
        paymentsItem.paymentType = "Credit card"

        /// Create the Order
        var order = Order()
        order.priceTotal = shoppingCart.total
        order.payments = [paymentsItem]

        /// Create Purchases action
        var purchases = Purchases()
        purchases.value = 1

        /// Create Commerce and add Purchases action and Order details
        var commerce = Commerce()
        commerce.order = order
        commerce.purchases = purchases

        // Compose the XDM Schema object and set the event name
        var xdmData = MobileSDKCommerceSchema()
        xdmData.eventType = Constants.AEP.COMMERCE_PURCHASE_EVENT
        xdmData.commerce = commerce
        xdmData.productListItems = shoppingCart.items

        // Create an Experience Event with the built schema and send it using the Platform extension
        let event = ExperiencePlatformEvent(xdm: xdmData)
        ExperiencePlatform.sendEvent(experiencePlatformEvent: event)
    }
}

struct ExperiencePlatformViewController_Previews: PreviewProvider {
    static var previews: some View {
        ExperiencePlatformView()
    }
}

