/*
 Copyright 2020 Adobe
 All Rights Reserved.
 
 NOTICE: Adobe permits you to use, modify, and distribute this file in
 accordance with the terms of the Adobe license agreement accompanying
 it.
 */

#import "MainTabBarController.h"

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSMutableArray *copyArray = [NSMutableArray arrayWithArray:
    [self viewControllers]];
    [copyArray removeObjectAtIndex:4];
    [copyArray removeObjectAtIndex:3];
    [copyArray removeObjectAtIndex:2];
    [self setViewControllers:copyArray animated:false];

    [self sampleCoreAPICalls];
}

- (void) sampleCoreAPICalls {
   // MARK: - Identity API examples
    NSString *identityVersion = [AEPMobileIdentity extensionVersion];
    NSLog(@"Identity version %@", identityVersion);
    
    /**
     Typical mobile web implementations use the same standard analytics s_code.js or AppMeasurement.js that is used in desktop sites. The JavaScript libraries have their own methods of generating unique visitor IDs, which causes a different visitor ID to be generated when you open mobile web content from your app.
     To use the same visitor ID in the app and mobile web and pass the visitor ID to the mobile web in the URL, complete the following steps:
     */

    /// To append visitor information to the URL that is being used to open the web view, call
    NSURL *sampleUrl = [NSURL URLWithString:@"https://adobe.com"];
    [AEPMobileIdentity appendToUrl:sampleUrl completion:^(NSURL * _Nullable url, enum AEPError error) {
        // Handle url or error
    }];

    /// Alternately, you can call getUrlVariables and build your own URL:
    [AEPMobileIdentity getUrlVariables:^(NSString * _Nullable variables, enum AEPError error) {
        NSString *sampleURLString = @"https://adobe.com";
        if (variables == nil) {
            // Handle variables being nil
            return;
        }
        NSString *stringWithData = [NSString stringWithFormat:@"%@?%@", sampleURLString, variables];
        NSURL *urlWithVisitorData = [NSURL URLWithString:stringWithData];
        NSLog(@"%@", [urlWithVisitorData absoluteString]);
    }];
    
    /**
     This API retrieves the ECID that was generated when the app was initially launched and is stored in the ECID Service.
     This ID is preserved between app upgrades, is saved and restored during the standard application backup process, and is removed at uninstall. The values are returned via the callback.
     */
    [AEPMobileIdentity getExperienceCloudId:^(NSString * _Nullable ecid) {
        if (ecid == nil) {
            // Handle nil ecid
            return;
        }
        
        NSLog(@"%@", ecid);
    }];
    
    /**
     This getIdentifiers API returns all customer identifiers that were previously synced with the Adobe Experience Cloud.
     */
    [AEPMobileIdentity getIdentifiers:^(NSArray<id<AEPIdentifiable>> * _Nullable identifiers, enum AEPError error) {
        if (identifiers == nil) {
            NSLog(@"Error getting identifiers: %ld", (long)error);
            return;
        }
        
        // Success, use the identifiers

    }];
    
    /**
     The advertising ID is preserved between app upgrades, is saved and restored during the standard application backup process, available via Signals, and is removed at uninstall.
     
     Retrieve the Identifier for Advertising (IDFA) from Apple APIs only if you are using an ad service. If you retrieve IDFA, and are not using it properly, your app might be rejected.
     
     NOTE: Starting in iOS 14 the API and process for using the IDFA has changed.
     */
    NSString *idfa = @"";
    if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
        idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    } else {
        NSLog(@"Advertising Tracking is disabled by the user, cannot process the advertising identifier");
    }
    
    [AEPMobileCore setAdvertisingIdentifier:idfa];
    
    /**
     This API sets the device token for push notifications in the SDK. If the current SDK privacy status is optedout, the push identifier is not set.
     */
    // Use the push token assigned via APNS
    NSData *pushToken = [[NSData alloc] init];
    [AEPMobileCore setPushIdentifier:pushToken];
    
    
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
    NSDictionary *identifierDict = @{@"idType": @"idValue"};
    [AEPMobileIdentity syncIdentifiers:identifierDict authenticationState: AEPMobileVisitorAuthStateUnknown];
    
    /**
     This API is an overloaded version, which does not include the parameter for the authentication state and it assumes a default value of MobileVisitorAuthenticationState.unknown
     
     The identifiers dictionary contains identifiers, and each identifier contains an identifier type as the key and an identifier as the value.
     If any of the identifier pairs contains an empty or null value as the identifier type, then it will be ignored.
     */
    NSDictionary *identifiersDictMult = @{@"idType1": @"idValue1", @"idType2": @"idValue2"};
    [AEPMobileIdentity syncIdentifiers:identifiersDictMult];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
