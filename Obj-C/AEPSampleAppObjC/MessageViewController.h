/*
 Copyright 2020 Adobe
 All Rights Reserved.
 
 NOTICE: Adobe permits you to use, modify, and distribute this file in
 accordance with the terms of the Adobe license agreement accompanying
 it.
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageViewController : UIViewController

- (IBAction)fullScreenButtonTapped:(id)sender;
- (IBAction)alertButtonTapped:(id)sender;
- (IBAction)largeModalTapped:(id)sender;
- (IBAction)smallModalButtonTapped:(id)sender;
- (IBAction)localNotificationButtonTapped:(id)sender;

@end

NS_ASSUME_NONNULL_END
