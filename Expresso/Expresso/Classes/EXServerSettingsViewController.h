//
//  EXServerSettingsViewController.h
//  Expresso
//
//  Created by Josef Lange on 4/10/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 *  ViewController to manage the user modifying server settings.
 */
@interface EXServerSettingsViewController : UIViewController <UITextViewDelegate, UIAlertViewDelegate>

/** The segmented control that selects which server is to be used. */
@property (weak, nonatomic) IBOutlet UISegmentedControl *serverSelector;
/** The text view that shows the server hostname (and port) */
@property (weak, nonatomic) IBOutlet UITextView *serverAddressTextView;
/** The button to save settings. */
@property (weak, nonatomic) IBOutlet UIButton *settingsSaver;
/** Popover controller that has presented this view. */
@property (weak, nonatomic) UIPopoverController *pop;


/**
 *  Respond to the server segmented control changing.
 *
 *  @param sender The UISegmentedControl sending the message.
 */
-(IBAction)selectionChanged:(UISegmentedControl *)sender;

/** 
 *  Save the settings set by the user.
 *
 *  @param sender   The sender of the message (usually UIButton...)
 */
-(IBAction)saveSettings:(id)sender;

@end
