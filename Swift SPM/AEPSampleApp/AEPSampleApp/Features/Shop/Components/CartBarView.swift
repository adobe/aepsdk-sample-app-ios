//
//  CartBarView.swift
//  AEPSampleApp
//
//  Pinned bar shown when the cart is non-empty. Tapping opens the Cart view;
//  the label previews count + subtotal.
//

import SwiftUI

struct CartBarView: View {
    let count: Int
    let subtotal: String
    let onOpenCart: () -> Void

    var body: some View {
        Button(action: onOpenCart) {
            HStack {
                Label("\(count) item\(count == 1 ? "" : "s")", systemImage: "cart.fill")
                    .font(.subheadline.weight(.semibold))
                Spacer()
                Text(subtotal).font(.subheadline.weight(.semibold))
                Image(systemName: "chevron.right").font(.caption.weight(.bold))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .background(.bar)
    }
}
