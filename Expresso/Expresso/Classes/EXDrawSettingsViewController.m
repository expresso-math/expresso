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

/**
 *  Force landscape.
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
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/**
 *  Overidden viewDidLoad to pre-set the stroke width selector to the current value.
 */
- (void)viewDidLoad
{
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

/**
 *  Stub for overriding.
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

/**
 * Change the stroke width in response to a UISegmentedControl.
 *
 * @param sender The message-sending object.
 */
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

@end
