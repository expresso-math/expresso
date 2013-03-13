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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    EXDrawingViewController *drawingViewController = (EXDrawingViewController *)[segue destinationViewController];
    drawingViewController.session = self.session;
}

- (IBAction)connectToSession:(id)sender {
    self.nextButton.enabled = NO;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.animationType = MBProgressHUDAnimationZoom;
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.graceTime = 0.25;
    hud.minShowTime = 2.0;
    hud.labelText = @"Starting Session";
    EXSession *newSession = [[EXSession alloc] initWithURL:[NSURL URLWithString:@"http://expresso-api.heroku.com"]];
    self.session = newSession;
    [newSession startSessionFrom:self];
}

- (void)receiveSession:(ASIHTTPRequest *)request {
    NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:request.responseData
                                                                 options:NSJSONReadingAllowFragments
                                                                   error:nil];
    self.session.sessionIdentifier = [responseData valueForKey:@"session_identifier"];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    self.nextButton.enabled = YES;
    [self performSegueWithIdentifier:@"WelcomeToDrawing" sender:self];

}

- (void)sessionFailed:(ASIHTTPRequest *)request {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Failed!" message:@"Barista is unreachable at the moment. Please try again later." delegate:self cancelButtonTitle:@"Oh well..." otherButtonTitles:@"Try again", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    switch (buttonIndex) {
        case 0:
            // Do nothing.
            self.nextButton.enabled = YES;
            break;
        case 1:
            [self connectToSession:self];
        default:
            break;
    }
}

@end
