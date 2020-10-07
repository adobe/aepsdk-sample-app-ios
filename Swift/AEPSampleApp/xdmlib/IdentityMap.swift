/*
 Copyright 2020 Adobe
 All Rights Reserved.
 
 NOTICE: Adobe permits you to use, modify, and distribute this file in
 accordance with the terms of the Adobe license agreement accompanying
 it.

----
 XDM Property Swift Object Generated 2020-07-17 14:52:38.219691 -0700 PDT m=+2.053129283 by XDMTool

 Title			:	IdentityMap
 Description	:	
----
*/

import Foundation


public struct IdentityMap {
	public init() {}

	public var items: Items?

	enum CodingKeys: String, CodingKey {
		case items = "items"
	}	
}

extension IdentityMap:Encodable {
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		if let unwrapped = items { try container.encode(unwrapped, forKey: .items) }
	}
}
