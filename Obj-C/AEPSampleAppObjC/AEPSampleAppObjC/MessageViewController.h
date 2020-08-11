//
//  MessageViewController.h
//  AEPSampleAppObjC
//
//  Created by Christopher Hoffman on 8/11/20.
//  Copyright © 2020 Christopher Hoffman. All rights reserved.
//

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
