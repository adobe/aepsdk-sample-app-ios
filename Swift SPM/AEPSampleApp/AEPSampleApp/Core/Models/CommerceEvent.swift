//
//  CommerceEvent.swift
//  AEPSampleApp
//
//  One discrete commerce interaction. Carries the structured XDM dictionary
//  (built by CommerceXDM) that the Edge service sends — one tap, one event.
//

enum CommerceEventType: String {
    case productListAdds    = "commerce.productListAdds"
    case productListRemoves = "commerce.productListRemoves"
    case purchases          = "commerce.purchases"
}

struct CommerceEvent {
    let type: CommerceEventType
    let xdm: [String: Any]
}
