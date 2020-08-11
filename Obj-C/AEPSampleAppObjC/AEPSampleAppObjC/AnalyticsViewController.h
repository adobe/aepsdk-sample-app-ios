//
//  SecondViewController.h
//  AEPSampleAppObjC
//
//  Created by Christopher Hoffman on 8/11/20.
//  Copyright © 2020 Christopher Hoffman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnalyticsViewController: UIViewController

@property (nonatomic, weak) IBOutlet UILabel *eventQueueLengthLabel;
@property (nonatomic, weak) IBOutlet UILabel *minBatchSizeLabel;
@property (nonatomic, weak) IBOutlet UILabel *trackingIdentifierLabel;
@property (nonatomic, weak) IBOutlet UILabel *visitorIdentifierLabel;
@property (nonatomic, weak) IBOutlet UIPickerView *optingPickerView;
@property (nonatomic, weak) IBOutlet UITextField *visitorIdentifierTextField;
@property (nonatomic, weak) IBOutlet UITextField *batchQueueLimitTextField;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

- (IBAction)sendQueuedHitsButtonTapped:(id)sender;
- (IBAction)clearQueueButtonTapped:(id)sender;
- (IBAction)sendTrackActionEventButtonTapped:(id)sender;
- (IBAction)sendTrackStateEventButtonTapped:(id)sender;
- (IBAction)updateButtonTapped:(id)sender;

@end

