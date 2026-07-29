//
//  CategoryBarView.swift
//  Nimbus
//
//  Horizontal category selector for Shop. Each chip switches the product filter
//  and the AJO content-card surface the Shop tab requests.
//

import SwiftUI

struct CategoryBarView: View {
    let selected: ShopCategory
    let onSelect: (ShopCategory) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(ShopCategory.allCases) { category in
                    let isOn = category == selected
                    Button { onSelect(category) } label: {
                        Label(category.title, systemImage: category.icon)
                            .font(.subheadline.weight(.medium))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(
                                Capsule().fill(isOn ? Color.accentColor
                                                    : Color(.secondarySystemBackground))
                            )
                            .foregroundStyle(isOn ? Color.white : Color.primary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
    }
}
