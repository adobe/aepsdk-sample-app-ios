/*
 Copyright 2020 Adobe
 All Rights Reserved.
 
 NOTICE: Adobe permits you to use, modify, and distribute this file in
 accordance with the terms of the Adobe license agreement accompanying
 it.
 
----
 XDM Swift Enum Generated 2020-07-17 14:52:38.217644 -0700 PDT m=+2.051081951 by XDMTool
----
*/
import Foundation

public enum AuthenticatedState:String, Encodable {
	case ambiguous // Ambiguous
	case authenticated // User identified by a login or similar action that was valid at the time of the event observation.
	case loggedOut // User was identified by a login action at some point of time previously, but is not currently logged in.
	 
}
