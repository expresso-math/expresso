//
//  EXServerSettingsViewController.m
//  Expresso
//
//  Created by Josef Lange on 4/10/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import "EXServerSettingsViewController.h"

@interface EXServerSettingsViewController ()

@end

@implementation EXServerSettingsViewController

@synthesize serverSelector = _serverSelector;
@synthesize serverAddressTextView = _serverAddressTextView;
@synthesize settingsSaver = _settingsSaver;

#pragma mark - Screen Orientation

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


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    NSNumber *selectedIndex = [[NSUserDefaults standardUserDefaults] objectForKey:@"selectedServerIndex"];
    NSString *serverHost = [[NSUserDefaults standardUserDefaults] objectForKey:@"serverHost"];
    [super viewDidLoad];
    [self.serverSelector setSelectedSegmentIndex:[selectedIndex intValue]];
    [self.serverAddressTextView setText:serverHost];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)selectionChanged:(UISegmentedControl *)sender {

    int index = [sender selectedSegmentIndex];
    switch (index) {
        case 0: {
            self.serverAddressTextView.text = @"http://expresso-api.herokuapp.com/";
            break;
        }
        case 1: {
            self.serverAddressTextView.text = @"http://localhost:5000/";
            break;
        }
        case 2: {
            self.serverAddressTextView.text = @"http://";
            break;
        }
    }
    
}

-(IBAction)saveSettings:(id)sender {
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    [d setObject:self.serverAddressTextView.text forKey:@"serverHost"];
    [d setObject:[NSNumber numberWithInt:self.serverSelector.selectedSegmentIndex] forKey:@"selectedServerIndex"];
    [self.presentingViewController dismissModalViewControllerAnimated:YES];
}


@end
