/*
 Copyright 2020 Adobe
 All Rights Reserved.
 
 NOTICE: Adobe permits you to use, modify, and distribute this file in
 accordance with the terms of the Adobe license agreement accompanying
 it.
 */

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [AEPMobileCore setLogLevel: AEPLogLevelTrace];
    
    const UIApplicationState appState = application.applicationState;

    NSArray *extensionsToRegister = @[
        AEPMobileIdentity.class,
        AEPMobileLifecycle.class,
        AEPMobileSignal.class,
        AEPMobileAssurance.class
    ];
    [AEPMobileCore registerExtensions:extensionsToRegister completion:^{
        // Use the App id assigned to this application via Adobe Launch
        [AEPMobileCore configureWithAppId: @""];
        
        if (appState != UIApplicationStateBackground) {
            [AEPMobileCore lifecycleStart:@{@"contextDataKey": @"contextDataVal"}];
        }
    }];

    
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
