//
//  EXServerSettingsViewController.h
//  Expresso
//
//  Created by Josef Lange on 4/10/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EXServerSettingsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *serverSelector;
@property (weak, nonatomic) IBOutlet UITextView *serverAddressTextView;
@property (weak, nonatomic) IBOutlet UIButton *settingsSaver;

-(IBAction)selectionChanged:(UISegmentedControl *)sender;
-(IBAction)saveSettings:(id)sender;

@end