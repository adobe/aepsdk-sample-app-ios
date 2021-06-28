/*
 Copyright 2020 Adobe
 All Rights Reserved.
 
 NOTICE: Adobe permits you to use, modify, and distribute this file in
 accordance with the terms of the Adobe license agreement accompanying
 it.
 */

#import <UIKit/UIKit.h>
@import AEPAssurance;

@interface AssuranceViewController: UIViewController

@property (nonatomic, weak) IBOutlet UITextField *assuranceSessionUrlField;
@property (nonatomic, weak) IBOutlet UIButton *connectButton;

- (IBAction)connectButtonTapped:(id)sender;


@end

