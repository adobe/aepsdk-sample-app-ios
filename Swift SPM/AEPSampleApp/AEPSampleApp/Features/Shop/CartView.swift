//
//  CartView.swift
//  AEPSampleApp
//
//  Shows current cart line items (adjustable), the subtotal, the session's
//  commerce-event inspector, and checkout. Presented as a sheet from Shop.
//

import SwiftUI

struct CartView: View {
    @Environment(AppEnvironment.self) private var env
    @Environment(\.dismiss) private var dismiss
    let model: ShopViewModel

    @State private var inspector: InspectorPayload?

    var body: some View {
        NavigationStack {
            List {
                if model.cartLines.isEmpty {
                    Text("Your cart is empty.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                } else {
                    Section("Items") {
                        ForEach(model.cartLines, id: \.product.id) { line in
                            lineRow(line.product, quantity: line.quantity)
                        }
                    }

                    Section {
                        LabeledContent("Subtotal",
                                       value: "$" + String(format: "%.2f", model.subtotal))
                            .font(.headline)
                    }
                }

                Section {
                    Button {
                        inspector = model.cartInspectorPayload()
                    } label: {
                        Label("Inspect commerce events (\(model.events.count))",
                              systemImage: "info.circle")
                    }
                }
            }
            .navigationTitle("Cart")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") { dismiss() }
                }
            }
            .safeAreaInset(edge: .bottom) {
                if !model.cartLines.isEmpty {
                    Button {
                        model.checkout(env)
                        dismiss()
                    } label: {
                        Text("Checkout · $" + String(format: "%.2f", model.subtotal))
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .padding(16)
                }
            }
            .sheet(item: $inspector) { InspectorSheet(payload: $0) }
        }
    }

    private func lineRow(_ product: Product, quantity: Int) -> some View {
        HStack(spacing: 12) {
            Image(systemName: product.imageSystemName)
                .font(.title3)
                .foregroundStyle(product.tint)
                .frame(width: 36, height: 36)
                .background(RoundedRectangle(cornerRadius: 8).fill(product.tint.opacity(0.15)))

            VStack(alignment: .leading, spacing: 2) {
                Text(product.name).font(.subheadline.weight(.medium))
                Text(product.formattedPrice).font(.caption).foregroundStyle(.secondary)
            }

            Spacer()

            HStack(spacing: 14) {
                Button { model.decrement(product, env) } label: {
                    Image(systemName: "minus.circle.fill")
                }
                Text("\(quantity)").font(.subheadline.monospacedDigit()).frame(minWidth: 16)
                Button { model.increment(product, env) } label: {
                    Image(systemName: "plus.circle.fill")
                }
            }
            .buttonStyle(.plain)
            .foregroundStyle(.tint)
        }
    }
}
