//
//  ShopView.swift
//  Nimbus
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
                CategoryBarView(selected: model.selectedCategory) { category in
                    model.selectCategory(category, env)
                }

                ScrollView {
                    VStack(alignment: .leading, spacing: 14) {
                        // Category-scoped AJO content card(s). `.id(surface)`
                        // rebuilds the view when the category changes, so the SDK
                        // re-requests the new surface.
                        SDKContentCardsView(surfacePath: model.selectedCategory.surface)
                            .id(model.selectedCategory.surface)
                            .padding(.horizontal, 16)

                        // Code-Based Experiences on the same category surface.
                        ShopCBEView(surfacePath: model.selectedCategory.surface)
                            .padding(.horizontal, 16)

                        LazyVGrid(columns: columns, spacing: 14) {
                            ForEach(model.visibleProducts) { product in
                                ProductTileView(
                                    product: product,
                                    quantity: model.quantity(for: product),
                                    onIncrement: { model.increment(product, env) },
                                    onDecrement: { model.decrement(product, env) }
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                    .padding(.top, 4)
                    .padding(.bottom, 16)
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
