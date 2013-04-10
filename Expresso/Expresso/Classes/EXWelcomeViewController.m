//
//  EXWelcomeViewController.m
//  Expresso
//
//  Created by Josef Lange on 3/8/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import "EXWelcomeViewController.h"
#import "EXServerSettingsViewController.h"

@interface EXWelcomeViewController ()

@end

@implementation EXWelcomeViewController

@synthesize nextButton = _nextButton;

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

# pragma mark - View Lifecycle

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
 *  Some setup for when the view loads. Set the background of the view.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *pattern = [UIImage imageNamed:@"honey_im_subtle"];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:pattern]];
}

/**
 * Stub for overriding.
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

# pragma mark - Session Request & Handling

// (Documented in header file)
- (IBAction)connectToSession:(id)sender {
    
    // Disable the next button.
    self.nextButton.enabled = NO;
    
    // Create and configure the HUD.
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.animationType = MBProgressHUDAnimationZoom;
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.graceTime = 0.25;
    hud.minShowTime = 2.0;
    hud.labelText = @"Starting Session";
    
    // Make a new session with the URL.
    
    NSString *serverHost = [[NSUserDefaults standardUserDefaults] objectForKey:@"serverHost"];
    NSURL *url = [NSURL URLWithString:serverHost];
    EXSession *newSession = [[EXSession alloc] initWithURL:url];
    self.session = newSession;
    
    // Tell the new session to start, and pass in self as the sender.
    [newSession startSessionFrom:self];
    
}

// (Documented in header file)
- (void)receiveSession:(ASIHTTPRequest *)request {
    
    // Read the response data into an NSDictionary.
    NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:request.responseData
                                                                 options:NSJSONReadingAllowFragments
                                                                   error:nil];    

    if([responseData valueForKey:@"session_identifier"]) {
        // Set the session identifier out of the response data.
        self.session.sessionIdentifier = [responseData valueForKey:@"session_identifier"];
        
        // Hide the HUDs.
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        // Re-enable the next button.
        self.nextButton.enabled = YES;
        
        // Perform the segues.
        [self performSegueWithIdentifier:@"WelcomeToDrawing" sender:self];
    } else {
        
        [self sessionFailed:request];
        
    }
}

// (Documented in header file)
- (void)sessionFailed:(ASIHTTPRequest *)request {
    
    // Make an alert view!
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Failed!" message:@"Barista is unreachable at the moment. Please try again later." delegate:self cancelButtonTitle:@"Oh well..." otherButtonTitles:@"Try again", nil];
    
    // Show it!
    [alert show];

}

#pragma mark - Training Preparation

-(IBAction)segueToTraining:(id)sender {
    [self performSegueWithIdentifier:@"WelcomeToTraining" sender:self];
}

#pragma mark - Server Settings

-(IBAction)showServerSettings:(id)sender {

    EXServerSettingsViewController *sC = (EXServerSettingsViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"serverSettings"];
    sC.modalPresentationStyle = UIModalPresentationPageSheet;
    sC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:sC animated:YES];
    sC.view.superview.autoresizingMask =
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleBottomMargin;
    sC.view.superview.frame = CGRectMake(
                                                     sC.view.superview.frame.origin.x,
                                                     sC.view.superview.frame.origin.y,
                                                     500.0f,
                                                     200.0f
                                                     );
    sC.view.superview.center = self.view.center;
}


#pragma mark - Segue

/**
 *  Pass the session forward.
 *
 *  @param  segue   The segue about to happen.
 *  @param  sender  The message sender.
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if( [segue.identifier isEqualToString:@"WelcomeToDrawing"] ) {
        EXDrawingViewController *drawingViewController = (EXDrawingViewController *)[segue destinationViewController];
        drawingViewController.session = self.session;
    }
}

#pragma mark - Alert View Protocol

/**
 *  Respond to the session failure alert view.
 *
 *  @param  alertView   The UIAlertView that was dismissed.
 *  @param  buttonIndex The index of the button pressed.
 */
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    // Hide the HUD.
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    switch (buttonIndex) {
        case 0:
            // Re-enable the next button.
            self.nextButton.enabled = YES;
            break;
        case 1:
            // Re-try.
            [self connectToSession:self];
            break;
        default:
            // Re-enable the next button.
            self.nextButton.enabled = YES;
            break;
    }
}

@end
