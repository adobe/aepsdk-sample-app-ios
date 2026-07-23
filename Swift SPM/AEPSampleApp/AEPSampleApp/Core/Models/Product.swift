//
//  Product.swift
//  AEPSampleApp
//
//  Pure local mock catalog data. Products are NEVER fetched from a backend —
//  they exist only to generate realistic commerce Edge events. `id` doubles
//  as the SKU used in XDM `productListItems`.
//

import SwiftUI

struct Product: Identifiable, Hashable {
    let id: String
    let name: String
    let price: Double
    let imageSystemName: String   // SF Symbol — keeps the mock asset-free
    let tint: Color

    var sku: String { id }

    var formattedPrice: String {
        "$" + String(format: "%.2f", price)
    }
}
