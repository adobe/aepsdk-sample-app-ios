//
//  FirstViewController.h
//  AEPSampleAppObjC
//
//  Created by Christopher Hoffman on 8/11/20.
//  Copyright © 2020 Christopher Hoffman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GriffonViewController: UIViewController

@property (nonatomic, weak) IBOutlet UITextField *griffonSessionUrlField;
@property (nonatomic, weak) IBOutlet UIButton *connectButton;
@property (nonatomic, weak) IBOutlet UIButton *disconnectButton;

- (IBAction)connectButtonTapped:(id)sender;
- (IBAction)disconnectButtonTapped:(id)sender;


@end

