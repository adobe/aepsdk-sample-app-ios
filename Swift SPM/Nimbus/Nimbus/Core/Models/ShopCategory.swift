//
//  ShopCategory.swift
//  Nimbus
//
//  Shop filter + AJO surface routing. `.all` is the store-wide filter and
//  surface; the remaining cases are the real product categories a Product
//  belongs to. Each case carries its own content-card surface so AJO can
//  target a different promo per category.
//

import Foundation

enum ShopCategory: String, CaseIterable, Identifiable {
    case all, apparel, accessories, gifts

    var id: String { rawValue }

    var title: String {
        switch self {
        case .all:         return "All"
        case .apparel:     return "Apparel"
        case .accessories: return "Accessories"
        case .gifts:       return "Gifts"
        }
    }

    var icon: String {
        switch self {
        case .all:         return "square.grid.2x2"
        case .apparel:     return "tshirt"
        case .accessories: return "bag"
        case .gifts:       return "gift"
        }
    }

    /// The AJO content-card surface for this category.
    var surface: String {
        switch self {
        case .all:         return SurfaceURI.shopAll
        case .apparel:     return SurfaceURI.shopApparel
        case .accessories: return SurfaceURI.shopAccessories
        case .gifts:       return SurfaceURI.shopGifts
        }
    }
}
