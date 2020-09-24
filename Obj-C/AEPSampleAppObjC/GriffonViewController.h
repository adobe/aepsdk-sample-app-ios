/*
 Copyright 2020 Adobe
 All Rights Reserved.
 
 NOTICE: Adobe permits you to use, modify, and distribute this file in
 accordance with the terms of the Adobe license agreement accompanying
 it.
 */

#import <UIKit/UIKit.h>

@interface GriffonViewController: UIViewController

@property (nonatomic, weak) IBOutlet UITextField *griffonSessionUrlField;
@property (nonatomic, weak) IBOutlet UIButton *connectButton;
@property (nonatomic, weak) IBOutlet UIButton *disconnectButton;

- (IBAction)connectButtonTapped:(id)sender;
- (IBAction)disconnectButtonTapped:(id)sender;


@end

