/*
 Copyright 2020 Adobe
 All Rights Reserved.
 
 NOTICE: Adobe permits you to use, modify, and distribute this file in
 accordance with the terms of the Adobe license agreement accompanying
 it.
 */

#import "AnalyticsViewController.h"

@implementation AnalyticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _optingOptions = @[@"Opt In", @"Opt Out", @"Opt Unknown"];
}

- (void)sendTrackStateEventButtonTapped:(id)sender {
    
}

- (void)sendTrackActionEventButtonTapped:(id)sender {
    
}

- (void)sendQueuedHitsButtonTapped:(id)sender {
    
}

- (void)clearQueueButtonTapped:(id)sender {
    
}

- (void)updateButtonTapped:(id)sender {
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _optingOptions.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _optingOptions[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _currentOptingChoice = _optingOptions[row];
}

@end
