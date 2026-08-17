//
//  CardCustomizer.swift
//  Nimbus
//
//  Uses the SDK's ContentCardCustomizing API to constrain the template image
//  size (AEPImage exposes sizing only via `.modifier`). This is the SDK's
//  documented customization hook — not a custom card view. Applied to both
//  getContentCardsUI and getInboxUI.
//

import SwiftUI
import AEPMessaging

struct CardCustomizer: ContentCardCustomizing {

    func customize(template: SmallImageTemplate) {
        template.image?.modifier = AEPViewModifier(ThumbnailModifier())
        template.image?.contentMode = .fit
    }

    func customize(template: LargeImageTemplate) {
        template.image?.modifier = AEPViewModifier(BannerImageModifier())
        template.image?.contentMode = .fill
    }

    // ImageOnly: leave the SDK default.
}

/// Square thumbnail for SmallImage cards (Home + Inbox rows).
private struct ThumbnailModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 88, height: 88)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

/// Constrained banner for LargeImage cards.
private struct BannerImageModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .frame(height: 140)
            .clipped()
    }
}
