//
//  CommerceXDM.swift
//  Nimbus
//
//  SINGLE SOURCE of commerce XDM payloads shaped to the Shubham Test Schema
//  (commerce mixin + productListItems). Pure Foundation — no SDK import — so
//  both the UI (inspector preview) and the real Edge service (actual send)
//  use the exact same dictionaries. Schema changes touch only this file.
//

import Foundation

enum CommerceXDM {

    /// One product add/remove: `commerce.<key>.value = 1` + a single line item.
    static func productEvent(type: CommerceEventType, product: Product) -> [String: Any] {
        let key = type.rawValue.replacingOccurrences(of: "commerce.", with: "")
        return [
            "eventType": type.rawValue,
            "commerce": [key: ["value": 1]],
            "productListItems": [[
                "SKU": product.sku,
                "name": product.name,
                "quantity": 1,
                "priceTotal": product.price
            ]]
        ]
    }

    /// A purchase covering the whole cart.
    static func purchase(cart: [String: Int], subtotal: Double) -> [String: Any] {
        let items: [[String: Any]] = MockCatalog.products.compactMap { product in
            guard let qty = cart[product.id], qty > 0 else { return nil }
            return [
                "SKU": product.sku,
                "name": product.name,
                "quantity": qty,
                "priceTotal": product.price * Double(qty)
            ]
        }
        return [
            "eventType": CommerceEventType.purchases.rawValue,
            "commerce": [
                "purchases": ["value": 1],
                "order": ["priceTotal": subtotal, "currencyCode": "USD"]
            ],
            "productListItems": items
        ]
    }
}
