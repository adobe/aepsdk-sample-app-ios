/*
 Copyright 2020 Adobe
 All Rights Reserved.
 
 NOTICE: Adobe permits you to use, modify, and distribute this file in
 accordance with the terms of the Adobe license agreement accompanying
 it.
 */

#import "AssuranceViewController.h"

@implementation AssuranceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)connectButtonTapped:(id)sender {
    NSString *assuranceUrl = _assuranceSessionUrlField.text;
    [AEPMobileAssurance startSessionWithUrl:[NSURL URLWithString:assuranceUrl]];
}

@end
