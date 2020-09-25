/*
 Copyright 2020 Adobe
 All Rights Reserved.
 
 NOTICE: Adobe permits you to use, modify, and distribute this file in
 accordance with the terms of the Adobe license agreement accompanying
 it.
 */

import UIKit
import AEPCore
import AEPIdentity
import AEPLifecycle
import AdSupport

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let griffonVC = GriffonViewController(rootView: GriffonView())
        griffonVC.tabBarItem = UITabBarItem(title: "Griffon", image: nil, selectedImage: nil)
        
        let analyticsVC = AnalyticsViewController(rootView: AnalyticsView())
        analyticsVC.tabBarItem = UITabBarItem(title: "Analytics", image: nil, selectedImage: nil)
        
//        let placesVC = PlacesViewController(rootView: PlacesView())
//        placesVC.tabBarItem = UITabBarItem(title: "Places", image: nil, selectedImage: nil)
//
//        let mediaVC = MediaViewController()
//        mediaVC.tabBarItem = UITabBarItem(title: "Media", image: nil, selectedImage: nil)
//
//        let messagesVC = MessagesViewController(rootView: MessagesView())
//        messagesVC.tabBarItem = UITabBarItem(title: "Messages", image: nil, selectedImage: nil)
        
        viewControllers = [griffonVC, analyticsVC/*, placesVC, mediaVC, messagesVC*/]
        
        // sampleCoreAPICalls
    }
    
    private func sampleCoreAPICalls() {
        // MARK: - Identity API examples
        let identityExtensionVersion = Identity.extensionVersion
        print("Identity extension version: \(identityExtensionVersion)")
        
        /**
         Typical mobile web implementations use the same standard analytics s_code.js or AppMeasurement.js that is used in desktop sites. The JavaScript libraries have their own methods of generating unique visitor IDs, which causes a different visitor ID to be generated when you open mobile web content from your app.
         To use the same visitor ID in the app and mobile web and pass the visitor ID to the mobile web in the URL, complete the following steps:
         */
        
        /// To append visitor information to the URL that is being used to open the web view, call
        let sampleUrl = URL(string: "https://adobe.com")
        Identity.appendTo(url: sampleUrl, completion: { (url, error) in
            // handle url or error
        })
        
        /// Alternately, you can call getUrlVariables and build your own URL:
        Identity.getUrlVariables(completion: { urlVariables, error in
            let sampleUrlStr = "https://adobe.com"
            guard let urlVariables = urlVariables else {
                // handle the urlVariables being nil
                return
            }
            let urlWithVisitorData = URL(string: sampleUrlStr + "?" + (urlVariables))
            //Handle url with visitor data
            print("URL String with Visitor Data: \(urlWithVisitorData?.absoluteString ?? "")")
        })
        
        /**
         This API retrieves the ECID that was generated when the app was initially launched and is stored in the ECID Service.
         This ID is preserved between app upgrades, is saved and restored during the standard application backup process, and is removed at uninstall. The values are returned via the callback.
         */
        Identity.getExperienceCloudId(completion: { id in
            guard let id = id else {
                // Handle id being nil
                return
            }
            
            // Use the ID
            print("ECID: \(id)")
        })
        
        /**
         This getIdentifiers API returns all customer identifiers that were previously synced with the Adobe Experience Cloud.
         */
        Identity.getIdentifiers(completion: { identifiers, error in
            guard let identifiers = identifiers else {
                // If identifiers is nil, handle the error
                print("Get identifiers error: \(error)")
                return
            }
            print("Identifiers: \(identifiers)")
        })
        
        /**
         The advertising ID is preserved between app upgrades, is saved and restored during the standard application backup process, available via Signals, and is removed at uninstall.
         
         Retrieve the Identifier for Advertising (IDFA) from Apple APIs only if you are using an ad service. If you retrieve IDFA, and are not using it properly, your app might be rejected.
         
         NOTE: Starting in iOS 14 the API and process for using the IDFA has changed.
         */
        var idfa:String = ""
        if (ASIdentifierManager.shared().isAdvertisingTrackingEnabled) {
            idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        } else {
            print("Advertising Tracking is disabled by the user, cannot process the advertising identifier")
        }
        MobileCore.setAdvertisingIdentifier(adId: idfa)
        
        /**
         This API sets the device token for push notifications in the SDK. If the current SDK privacy status is optedout, the push identifier is not set.
         */
        // Use the push token assigned via APNS
        let pushTokenData = Data()
        MobileCore.setPushIdentifier(deviceToken: pushTokenData)
        
        /**
         The syncIdentifier() and syncIdentifiers() APIs update the specified customer IDs with the Adobe Experience Cloud ID (ECID) Service.
         These APIs synchronize the provided customer identifier type key and value with the authentication state to the ECID Service. If the specified customer ID type exists in the service, this ID type is updated with the new ID and the authentication state. Otherwise, a new customer ID is added.
         Starting with ACPIdentity v2.1.3 (iOS) and Identity v1.1.2 (Android) if the new identifier value is null or empty, this ID type is removed from the local storage, Identity shared state and not synced with the Adobe ECID Service.
         These IDs are preserved between app upgrades, are saved and restored during the standard application backup process, and are removed at uninstall.
         If the current SDK privacy status is MobilePrivacyStatus.OPT_OUT, calling this method results in no operations being performed.
         This API updates or appends the provided customer identifier type key and value with the given authentication state to the ECID Service. If the specified customer ID type exists in the service, the ID is updated with the new ID and authentication state. Otherwise a new customer ID is added.
         */
        
        /**
         The identifierType (String) contains the identifier type, and this parameter should not be null or empty.
         The identifier (String) contains the identifier value, and this parameter should not be null or empty.
         If either the identifier type or identifier contains a null or an empty string, the identifier is ignored by the Identity extension.
         The authenticationState (VisitorIDAuthenticationState) value indicates the authentication state for the user and contains one of the following VisitorID.AuthenticationState values:
         MobileVisitorAuthenticationState.authenticated
         MobileVisitorAuthenticationState.loggedOut
         MobileVisitorAuthenticationState.unknown
         */
        Identity.syncIdentifier(identifierType: "idType", identifier: "idValue", authenticationState: .unknown)
        
        /**
         This API is an overloaded version, which does not include the parameter for the authentication state and it assumes a default value of MobileVisitorAuthenticationState.unknown
         
         The identifiers dictionary contains identifiers, and each identifier contains an identifier type as the key and an identifier as the value.
         If any of the identifier pairs contains an empty or null value as the identifier type, then it will be ignored.
         */
        let identifiers = ["idType1": "idValue1", "idType2": "idValue2"]
        Identity.syncIdentifiers(identifiers: identifiers)
        /**
         Same as above except you can indicate the authentication state of the user
         */
        Identity.syncIdentifiers(identifiers: identifiers, authenticationState: .authenticated)
        
        // MARK: - Old APIs
        //        Lifecycle.registerExtension()
        //        Identity.registerExtension()
        //        MobileCore.start {
        //            MobileCore.lifecycleStart(additionalContextData: nil)
        //        }
    }
    
    


}



