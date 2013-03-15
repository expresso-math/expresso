//
//  EXWelcomeViewController.m
//  Expresso
//
//  Created by Josef Lange on 3/8/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import "EXWelcomeViewController.h"

@interface EXWelcomeViewController ()

@end

@implementation EXWelcomeViewController

@synthesize nextButton = _nextButton;

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
 *  Some setup for when the view loads. Set the background of the view.
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *pattern = [UIImage imageNamed:@"honey_im_subtle"];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:pattern]];
}

/**
 * Stub for overriding.
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/**
 *  Pass the session forward.
 *
 *  @param  segue   The segue about to happen.
 *  @param  sender  The message sender.
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    EXDrawingViewController *drawingViewController = (EXDrawingViewController *)[segue destinationViewController];
    drawingViewController.session = self.session;
}

/**
 *  Respond to the "Connect" button by starting an API call for a session.
 * 
 *  @param  sender  The message sender.
 */
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
    EXSession *newSession = [[EXSession alloc] initWithURL:[NSURL URLWithString:@"http://expresso-api.heroku.com/"]];
    self.session = newSession;
    
    // Tell the new session to start, and pass in self as the sender.
    [newSession startSessionFrom:self];
    
}

/**
 *  Method called by ASIHTTPRequest when the request for a session has successfully completed.
 *
 *  @param  request The request that has successfully completed.
 */
- (void)receiveSession:(ASIHTTPRequest *)request {
    
    // Read the response data into an NSDictionary.
    NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:request.responseData
                                                                 options:NSJSONReadingAllowFragments
                                                                   error:nil];
    
    // Set the session identifier out of the response data.
    self.session.sessionIdentifier = [responseData valueForKey:@"session_identifier"];
    
    // Hide the HUDs.
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    // Re-enable the next button.
    self.nextButton.enabled = YES;
    
    // Perform the segues.
    [self performSegueWithIdentifier:@"WelcomeToDrawing" sender:self];

}

/**
 *  Method called by ASIHTTPRequest when the request for a session has failed.
 *
 *  @param  request The request that has failed.
 */
- (void)sessionFailed:(ASIHTTPRequest *)request {
    
    // Make an alert view!
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Failed!" message:@"Barista is unreachable at the moment. Please try again later." delegate:self cancelButtonTitle:@"Oh well..." otherButtonTitles:@"Try again", nil];
    
    // Show it!
    [alert show];

}

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
