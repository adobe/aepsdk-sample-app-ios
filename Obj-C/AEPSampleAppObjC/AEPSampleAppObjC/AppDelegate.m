//
//  AppDelegate.m
//  AEPSampleAppObjC
//
//  Created by Christopher Hoffman on 8/11/20.
//  Copyright © 2020 Christopher Hoffman. All rights reserved.
//

#import "AppDelegate.h"
@import AEPCore;
@import AEPLifecycle;
@import AEPIdentity;
@import AdSupport;
@import AVKit;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSArray *extensionsToRegister = @[AEPIdentity.class, AEPLifecycle.class];
    [AEPCore registerExtensions:extensionsToRegister completion:^{
        [AEPCore lifecycleStart:nil];
    }];
    
    // Use the App id assigned to this application via Adobe Launch
    [AEPCore configureWithAppId: @""];
    
    NSDictionary *updatedConfig = @{ @"analytics.rsids": @"mobile5mob40541autoapp11490299390559"};
    [AEPCore updateConfiguration:updatedConfig];
    
    // MARK: - Identity API examples
    NSInteger identityVersion = [AEPIdentity version];
    NSLog(@"Identity version %ld", (long)identityVersion);
    
    /**
     Typical mobile web implementations use the same standard analytics s_code.js or AppMeasurement.js that is used in desktop sites. The JavaScript libraries have their own methods of generating unique visitor IDs, which causes a different visitor ID to be generated when you open mobile web content from your app.
     To use the same visitor ID in the app and mobile web and pass the visitor ID to the mobile web in the URL, complete the following steps:
     */

    /// To append visitor information to the URL that is being used to open the web view, call
    NSURL *sampleUrl = [NSURL URLWithString:@"https://adobe.com"];
    [AEPIdentity appendToUrl:sampleUrl completion:^(NSURL * _Nullable url, enum AEPError error) {
        // Handle url or error
    }];

    /// Alternately, you can call getUrlVariables and build your own URL:
    [AEPIdentity getUrlVariables:^(NSString * _Nullable variables, enum AEPError error) {
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
    [AEPIdentity getExperienceCloudId:^(NSString * _Nullable ecid) {
        if (ecid == nil) {
            // Handle nil ecid
            return;
        }
        
        NSLog(@"%@", ecid);
    }];
    
    /**
     This getIdentifiers API returns all customer identifiers that were previously synced with the Adobe Experience Cloud.
     */
    [AEPIdentity getIdentifiers:^(NSArray<id<AEPIdentifiable>> * _Nullable identifiers, enum AEPError error) {
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
    
    [AEPCore setAdvertisingIdentifier:idfa];
    
    /**
     This API sets the device token for push notifications in the SDK. If the current SDK privacy status is optedout, the push identifier is not set.
     */
    // Use the push token assigned via APNS
    NSData *pushToken = [[NSData alloc] init];
    [AEPCore setPushIdentifier:pushToken];
    
    
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
    [AEPIdentity syncIdentifiers:identifierDict authenticationState: AEPMobileVisitorAuthStateUnknown];
    
    /**
     This API is an overloaded version, which does not include the parameter for the authentication state and it assumes a default value of MobileVisitorAuthenticationState.unknown
     
     The identifiers dictionary contains identifiers, and each identifier contains an identifier type as the key and an identifier as the value.
     If any of the identifier pairs contains an empty or null value as the identifier type, then it will be ignored.
     */
    NSDictionary *identifiersDictMult = @{@"idType1": @"idValue1", @"idType2": @"idValue2"};
    [AEPIdentity syncIdentifiers:identifiersDictMult];
    
    /// AudioSession for use with the Media Tab
    @try {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback mode:AVAudioSessionModeMoviePlayback options:AVAudioSessionCategoryOptionDuckOthers error:nil];
    } @catch (NSException *exception) {
        NSLog(@"Setting category to AVAudioSessionCategoryPlayback failed");
    }
    
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
