//
//  MockCatalog.swift
//  AEPSampleApp
//
//  Local mock catalog. The catalog is NOT an SDK concern and will never be
//  fetched remotely, so it lives as plain static data (no JSON file / bundle
//  lookup that could fail at runtime). It only exists to feed realistic
//  commerce Edge events.
//

import SwiftUI

enum MockCatalog {
    static let products: [Product] = [
        Product(id: "TEE-01",   name: "Everyday Tee",   price: 20, imageSystemName: "tshirt.fill",     tint: .blue),
        Product(id: "SHADE-01", name: "Sun Shades",     price: 25, imageSystemName: "sunglasses.fill", tint: .orange),
        Product(id: "BAG-01",   name: "Weekender Bag",  price: 40, imageSystemName: "bag.fill",        tint: .green),
        Product(id: "GIFT-01",  name: "Gift Card",      price: 50, imageSystemName: "giftcard.fill",   tint: .pink),
    ]
}
