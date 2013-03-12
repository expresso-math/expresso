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

@interface EXDrawSettingsViewController : UIViewController

@property (strong, nonatomic) UIPopoverController *myPopoverController;
@property (weak, nonatomic) IBOutlet UISegmentedControl *strokeWidthSelector;

-(IBAction)selectedStrokeWith:(id)sender;

@end
