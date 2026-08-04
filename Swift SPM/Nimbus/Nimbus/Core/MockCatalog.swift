//
//  MockCatalog.swift
//  Nimbus
//
//  Local mock catalog. The catalog is NOT an SDK concern and will never be
//  fetched remotely, so it lives as plain static data (no JSON file / bundle
//  lookup that could fail at runtime). It only exists to feed realistic
//  commerce Edge events.
//

import SwiftUI

enum MockCatalog {
    static let products: [Product] = [
        Product(id: "TEE-01",   name: "Everyday Tee",  price: 20, imageSystemName: "tshirt.fill",      tint: .blue,   category: .apparel),
        Product(id: "HOOD-01",  name: "Cozy Hoodie",   price: 45, imageSystemName: "hanger",           tint: .indigo, category: .apparel),
        Product(id: "SHADE-01", name: "Sun Shades",    price: 25, imageSystemName: "sunglasses.fill",  tint: .orange, category: .accessories),
        Product(id: "BAG-01",   name: "Weekender Bag", price: 40, imageSystemName: "bag.fill",         tint: .green,  category: .accessories),
        Product(id: "GIFT-01",  name: "Gift Card",     price: 50, imageSystemName: "giftcard.fill",    tint: .pink,   category: .gifts),
        Product(id: "BOX-01",   name: "Gift Box",      price: 35, imageSystemName: "shippingbox.fill", tint: .brown,  category: .gifts),
    ]
}
