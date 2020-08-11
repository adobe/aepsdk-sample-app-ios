//
//  PlacesViewController.h
//  AEPSampleAppObjC
//
//  Created by Christopher Hoffman on 8/11/20.
//  Copyright © 2020 Christopher Hoffman. All rights reserved.
//

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
