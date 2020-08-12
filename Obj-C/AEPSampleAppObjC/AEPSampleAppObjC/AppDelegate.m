//
//  AppDelegate.m
//  AEPSampleAppObjC
//
//  Created by Christopher Hoffman on 8/11/20.
//  Copyright © 2020 Christopher Hoffman. All rights reserved.
//

#import "AppDelegate.h"

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
