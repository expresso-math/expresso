//
//  EXServerSettingsViewController.m
//  Expresso
//
//  Created by Josef Lange on 4/10/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import "EXServerSettingsViewController.h"
#import "EXWelcomeViewController.h"

@interface EXServerSettingsViewController ()

@end

@implementation EXServerSettingsViewController

@synthesize serverSelector = _serverSelector;
@synthesize serverAddressTextView = _serverAddressTextView;
@synthesize settingsSaver = _settingsSaver;
@synthesize pop = _pop;

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

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    if([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
    
        UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"Custom Server" message:@"Enter Custom Server" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Submit", nil];
        a.alertViewStyle = UIAlertViewStylePlainTextInput;
        [a show];
        
        return NO;
        
    }
    
    return YES;
    
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
    self.serverAddressTextView.delegate = self;
    
	// Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated {
    [self save];
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

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSLog(@"%d", buttonIndex);
    if(buttonIndex==1) {
        NSString *newServer = [[alertView textFieldAtIndex:0] text];
        self.serverAddressTextView.text = newServer;
        [self.serverAddressTextView endEditing:YES];
    }
}

-(void)save {
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    [d setObject:self.serverAddressTextView.text forKey:@"serverHost"];
    [d setObject:[NSNumber numberWithInt:self.serverSelector.selectedSegmentIndex] forKey:@"selectedServerIndex"];
}

-(IBAction)saveSettings:(id)sender {
    [self.presentingViewController dismissModalViewControllerAnimated:YES];
    [self.pop dismissPopoverAnimated:YES];
    [(EXWelcomeViewController *)self.pop.delegate setPop:nil];
}


@end
