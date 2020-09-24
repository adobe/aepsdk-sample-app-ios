/*
 Copyright 2020 Adobe
 All Rights Reserved.
 
 NOTICE: Adobe permits you to use, modify, and distribute this file in
 accordance with the terms of the Adobe license agreement accompanying
 it.
 */

#import <UIKit/UIKit.h>

@interface PlacesViewController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *monitoringStatusLabel;
@property (nonatomic, weak) IBOutlet UILabel *monitoringTypeLabel;
@property (nonatomic, weak) IBOutlet UILabel *currentLocationLabel;
@property (nonatomic, weak) IBOutlet UILabel *lastKnownLocationLabel;

- (IBAction)startMonitoringButtonTapped:(id)sender;
- (IBAction)stopMonitoringButtonTapped:(id)sender;
- (IBAction)monitorAlwaysButtonTapped:(id)sender;
- (IBAction)monitorWhileUsingButtonTapped:(id)sender;
- (IBAction)currentLocationButtonTapped:(id)sender;

@end
