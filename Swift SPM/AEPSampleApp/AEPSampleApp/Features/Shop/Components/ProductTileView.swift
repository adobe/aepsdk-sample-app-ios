//
//  ProductTileView.swift
//  AEPSampleApp
//
//  Minimal commerce surface. The stepper is the entire "shop" — each +/- tap
//  fires one discrete commerce event via the view model.
//

import SwiftUI

struct ProductTileView: View {
    let product: Product
    let quantity: Int
    let onIncrement: () -> Void
    let onDecrement: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            // Tinted "product image" tile using an SF Symbol.
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(product.tint.gradient.opacity(0.18))
                Image(systemName: product.imageSystemName)
                    .font(.system(size: 40, weight: .semibold))
                    .foregroundStyle(product.tint)
            }
            .frame(height: 96)

            VStack(spacing: 2) {
                Text(product.name).font(.subheadline.weight(.semibold))
                Text(product.formattedPrice).font(.caption).foregroundStyle(.secondary)
            }

            HStack(spacing: 18) {
                stepperButton("minus", action: onDecrement)
                    .disabled(quantity == 0)
                    .opacity(quantity == 0 ? 0.4 : 1)
                Text("\(quantity)")
                    .font(.subheadline.monospacedDigit().weight(.medium))
                    .frame(minWidth: 18)
                stepperButton("plus", action: onIncrement)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
    }

    private func stepperButton(_ icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.footnote.weight(.bold))
                .frame(width: 30, height: 30)
                .background(Circle().fill(product.tint.opacity(0.15)))
                .foregroundStyle(product.tint)
        }
        .buttonStyle(.plain)
    }
}
