/*
Copyright 2020 Adobe. All rights reserved.
This file is licensed to you under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License. You may obtain a copy
of the License at http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under
the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR REPRESENTATIONS
OF ANY KIND, either express or implied. See the License for the specific language
governing permissions and limitations under the License.
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

