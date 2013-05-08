//
//  EXEquationViewController.m
//  Expresso
//
//  Created by Josef Lange on 5/7/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import "EXEquationViewController.h"
#import "EXEquation.h"
#import <MessageUI/MFMailComposeViewController.h>


@interface EXEquationViewController ()

@end

@implementation EXEquationViewController



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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.imageView.contentMode = UIViewContentModeCenter;
    EXEquation *equation = (EXEquation *)[self.session.currentExpression.equations objectAtIndex:0];
    self.imageView.image = equation.equationImage;
    self.textView.text = equation.latexEncoding;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)copyCode:(id)sender {
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    pb.string = self.textView.text;
    [[[UIAlertView alloc] initWithTitle:@"Copied!" message:nil delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles: nil] show];
}

- (IBAction)emailCode:(id)sender {
    MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
    mail.mailComposeDelegate = self;
    [mail setSubject:[NSString stringWithFormat:@"LaTeX code for Expresso Session %@", self.session.sessionIdentifier]];
    [mail setMessageBody:self.textView.text isHTML:NO];
    if (mail) [self presentModalViewController:mail animated:YES];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)startOver:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
