//
//  ShopViewModel.swift
//  AEPSampleApp
//
//  Owns the minimal mock cart. Each +/- tap builds one CommerceEvent and hands
//  it to AnalyticsService — one tap, one discrete event (tapping "+" twice
//  fires two separate events, not quantity: 2). Checkout fires the purchase
//  event that (Stage 3b) triggers an AJO in-app message.
//

import Foundation
import Observation

@Observable
final class ShopViewModel {

    /// Local mock cart: product id -> quantity.
    private(set) var cart: [String: Int] = [:]

    var cartCount: Int { cart.values.reduce(0, +) }

    var subtotal: Double {
        cartLines.reduce(0) { $0 + $1.product.price * Double($1.quantity) }
    }

    /// Current cart contents as displayable line items.
    var cartLines: [(product: Product, quantity: Int)] {
        MockCatalog.products.compactMap { product in
            guard let qty = cart[product.id], qty > 0 else { return nil }
            return (product, qty)
        }
    }

    func quantity(for product: Product) -> Int { cart[product.id] ?? 0 }

    // MARK: Commerce intents — each fires exactly one discrete event

    func increment(_ product: Product, _ env: AppEnvironment) {
        cart[product.id, default: 0] += 1
        fire(.productListAdds, product: product, env: env)
        // Named action an AJO in-app "add-to-cart nudge" campaign can trigger on.
        env.analytics.trackAction("add-to-cart", data: ["sku": product.sku])
    }

    func decrement(_ product: Product, _ env: AppEnvironment) {
        guard quantity(for: product) > 0 else { return }
        cart[product.id]! -= 1
        if cart[product.id] == 0 { cart[product.id] = nil }
        fire(.productListRemoves, product: product, env: env)
    }

    func checkout(_ env: AppEnvironment) {
        guard cartCount > 0 else { return }
        // STAGE 3b: this purchase event is the trigger that makes AJO surface
        // an in-app "thank you / cross-sell" message.
        let event = CommerceEvent(
            type: .purchases, productName: nil, timestamp: .now,
            xdm: CommerceXDM.purchase(cart: cart, subtotal: subtotal)
        )
        env.analytics.track(event)
        // STAGE 3b: named action AJO in-app rules can trigger on (the
        // "thank you / cross-sell" message).
        env.analytics.trackAction("order-complete", data: ["orderTotal": String(format: "%.2f", subtotal)])
        cart.removeAll()
    }

    // MARK: Helpers

    private func fire(_ type: CommerceEventType, product: Product, env: AppEnvironment) {
        let event = CommerceEvent(
            type: type, productName: product.name, timestamp: .now,
            xdm: CommerceXDM.productEvent(type: type, product: product)
        )
        env.analytics.track(event)
    }
}
