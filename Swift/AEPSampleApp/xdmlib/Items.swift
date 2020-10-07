/*
 Copyright 2020 Adobe
 All Rights Reserved.
 
 NOTICE: Adobe permits you to use, modify, and distribute this file in
 accordance with the terms of the Adobe license agreement accompanying
 it.

----
 XDM Property Swift Object Generated 2020-07-17 14:52:38.21778 -0700 PDT m=+2.051218117 by XDMTool

 Title			:	Items
 Description	:	
----
*/

import Foundation


public struct Items {
	public init() {}

	public var authenticatedState: AuthenticatedState?
	public var id: String?
	public var primary: Bool?

	enum CodingKeys: String, CodingKey {
		case authenticatedState = "authenticatedState"
		case id = "id"
		case primary = "primary"
	}	
}

extension Items:Encodable {
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		if let unwrapped = authenticatedState { try container.encode(unwrapped, forKey: .authenticatedState) }
		if let unwrapped = id { try container.encode(unwrapped, forKey: .id) }
		if let unwrapped = primary { try container.encode(unwrapped, forKey: .primary) }
	}
}
