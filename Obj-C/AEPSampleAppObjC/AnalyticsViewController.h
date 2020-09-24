/*
 Copyright 2020 Adobe
 All Rights Reserved.
 
 NOTICE: Adobe permits you to use, modify, and distribute this file in
 accordance with the terms of the Adobe license agreement accompanying
 it.
 */

#import <UIKit/UIKit.h>

@interface AnalyticsViewController: UIViewController<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, weak) IBOutlet UILabel *eventQueueLengthLabel;
@property (nonatomic, weak) IBOutlet UILabel *minBatchSizeLabel;
@property (nonatomic, weak) IBOutlet UILabel *trackingIdentifierLabel;
@property (nonatomic, weak) IBOutlet UILabel *visitorIdentifierLabel;
@property (nonatomic, weak) IBOutlet UIPickerView *optingPickerView;
@property (nonatomic, weak) IBOutlet UITextField *visitorIdentifierTextField;
@property (nonatomic, weak) IBOutlet UITextField *batchQueueLimitTextField;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *optingOptions;
@property (nonatomic, strong) NSString *currentOptingChoice;

- (IBAction)sendQueuedHitsButtonTapped:(id)sender;
- (IBAction)clearQueueButtonTapped:(id)sender;
- (IBAction)sendTrackActionEventButtonTapped:(id)sender;
- (IBAction)sendTrackStateEventButtonTapped:(id)sender;
- (IBAction)updateButtonTapped:(id)sender;

@end
