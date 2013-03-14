//
//  EXDrawSettingsViewController.h
//  Expresso
//
//  Created by Josef Lange on 3/8/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UIButton+Glossy.h"

/**
 *  View controller to manage the draw settings UIPopover (or page-curl view on iPhone)
 */

@interface EXDrawSettingsViewController : UIViewController

/** The Popover Controller that presents this ViewController on iPad. */
@property (strong, nonatomic) UIPopoverController *myPopoverController;
/** The UISegmentedControl the user uses to choose stroke width. */
@property (weak, nonatomic) IBOutlet UISegmentedControl *strokeWidthSelector;

/**
 * Change the stroke width in response to a UISegmentedControl.
 *
 * @param sender The message-sending object.
 */
-(IBAction)selectedStrokeWidth:(id)sender;

@end
