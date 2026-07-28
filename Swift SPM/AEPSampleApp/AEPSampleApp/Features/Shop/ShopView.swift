//
//  ShopView.swift
//  AEPSampleApp
//
//  Minimal commerce tab: a product grid whose steppers fire real commerce
//  Edge events, plus a pinned cart bar that opens the Cart view.
//

import SwiftUI

struct ShopView: View {
    @Environment(AppEnvironment.self) private var env
    @State private var model = ShopViewModel()
    @State private var showCart = false

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 14) {
                        ForEach(MockCatalog.products) { product in
                            ProductTileView(
                                product: product,
                                quantity: model.quantity(for: product),
                                onIncrement: { model.increment(product, env) },
                                onDecrement: { model.decrement(product, env) }
                            )
                        }
                    }
                    .padding(16)
                }

                if model.cartCount > 0 {
                    CartBarView(
                        count: model.cartCount,
                        subtotal: "$" + String(format: "%.2f", model.subtotal),
                        onOpenCart: { showCart = true }
                    )
                }
            }
            .navigationTitle("Shop")
            .onAppear { env.analytics.trackState("shop", data: nil) }
            .sheet(isPresented: $showCart) { CartView(model: model) }
        }
    }
}
