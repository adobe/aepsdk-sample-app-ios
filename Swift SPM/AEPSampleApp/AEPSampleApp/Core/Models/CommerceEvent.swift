//
//  CommerceEvent.swift
//  AEPSampleApp
//
//  Represents one discrete commerce interaction. Carries the structured XDM
//  dictionary (built by CommerceXDM) so the real Edge service sends it directly
//  and the inspector renders the same payload — one tap, one event.
//

import Foundation

enum CommerceEventType: String {
    case productListAdds    = "commerce.productListAdds"
    case productListRemoves = "commerce.productListRemoves"
    case purchases          = "commerce.purchases"
}

struct CommerceEvent: Identifiable {
    let id = UUID()
    let type: CommerceEventType
    let productName: String?
    let timestamp: Date
    let xdm: [String: Any]

    /// Schema-shaped payload preview for the inspector.
    var xdmJSON: String { CommerceXDM.prettyJSON(xdm) }
}
