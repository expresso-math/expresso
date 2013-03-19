//
//  EXDrawSettingsViewController.m
//  Expresso
//
//  Created by Josef Lange on 3/8/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import "EXDrawSettingsViewController.h"

@interface EXDrawSettingsViewController ()

@end

@implementation EXDrawSettingsViewController

@synthesize myPopoverController = _myPopoverController;

#pragma mark - View Lifecycle

/**
 *  Force landscape.
 *
 *  @param interfaceOrientation The interface orientation.
 *  @return Whether or not we should autorotate to a given orientation.
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    switch (interfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:{
            return YES;
        } break;
        case UIInterfaceOrientationLandscapeRight: {
            return YES;
        } break;
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
        default: {
            return NO;
        } break;
    }
}

/**
 *  Stub for overriding.
 *
 *  @param  nibNameOrNil The NIB name (or nil).
 *  @param  nibBundleOrNil  The NIB Bundle (or nil).
 *
 *  @return The object.
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/**
 *  Overidden viewDidLoad to pre-set the stroke width selector to the current value.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSNumber *savedStrokeWidth = [[NSUserDefaults standardUserDefaults] valueForKey:@"strokeWidth"];
    switch ([savedStrokeWidth intValue]) {
        case 1:
            self.strokeWidthSelector.selectedSegmentIndex = 0;
            break;
        case 3:
            self.strokeWidthSelector.selectedSegmentIndex = 1;
            break;
        case 5:
            self.strokeWidthSelector.selectedSegmentIndex = 2;
            break;
        default:
            [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:3] forKey:@"strokeWidth"];
            self.strokeWidthSelector.selectedSegmentIndex = 1;
    }
    
}

#pragma mark - View Manipulation

/**
 *  Dismiss the settings view.
 *
 *  Depending on platform, either dismisses pagecurl or dismisses popover.
 */
- (void)hide {
    if([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
        // Cancel settings iPhone way, page-curl.
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        // Cancel settings iPad way, popover.
        UIPopoverController *popCon = self.myPopoverController;
        [popCon dismissPopoverAnimated:YES];
        [popCon.delegate popoverControllerDidDismissPopover:popCon];
    }

}

#pragma mark - IBActions

// (Documented in header file)
- (IBAction)selectedStrokeWidth:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    switch ([segmentedControl selectedSegmentIndex]) {
        case 0:
            [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:1] forKey:@"strokeWidth"];
            break;
        case 1:
            [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:3] forKey:@"strokeWidth"];
            break;
        case 2:
            [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:5] forKey:@"strokeWidth"];
            break;
            
        default:
            [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:3] forKey:@"strokeWidth"];
            break;
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self hide];
}

#pragma mark - Screen Orientation




@end
