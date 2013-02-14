//
//  EXViewController.m
//  Expresso
//
//  Created by Josef Lange on 2/6/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import "EXViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface EXViewController ()

@end

@implementation EXViewController

@synthesize restClient = _restClient; // Synth restClient into an instance variable.
@synthesize settingsPopoverController = _settingsPopoverController;

/*
 *  Help force landscape.
 */
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortrait);
}

/*
 *  Setup stuff for when the main View loads. Background colors, state setup, etc.
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSNotificationCenter *n = [NSNotificationCenter defaultCenter];
    [n addObserver:self selector:@selector(strokeWidthDidChange:) name:@"strokeWidthDidChange" object:nil];
    
    [self.mainView setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:1.0]];

    self.drawingView.strokeWidth = [NSNumber numberWithInt:3];
    
    [[self.progressView layer] setCornerRadius:5.0];
    [[self.progressView layer] setMasksToBounds:YES];

}

- (void)strokeWidthDidChange:(NSNotification *)notification {
    NSNumber *num = [[notification userInfo] valueForKey:@"newStrokeWidth"];
    self.drawingView.strokeWidth = num;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 *  set members to nil to be easy on memory.
 */
- (void)viewDidUnload {
    [self setMainView:nil];
    [self setDrawingView:nil];
    //[self setStrokeWidthSlider:nil];
    //[self setStrokeWidthLabel:nil];
    [super viewDidUnload];
}

/*
 *  Receive target action for clear from the button and send it to the drawingView.
 */
- (IBAction)clearDrawing:(id)sender {
    [self.drawingView eraseView];
}

/*
 *  Lazily instantiate the DropBox REST client in the getter.
 */
- (DBRestClient *)restClient {
    if (!_restClient) {
        _restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        _restClient.delegate = self;
    }
    return _restClient;
}

- (IBAction)showOptions:(UIButton *)sender {
        EXSettingsPopoverContentViewController *settingsView = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsPopoverViewController"];
    
    
    UIPopoverController *popController = [[UIPopoverController alloc] initWithContentViewController:settingsView];
    
    popController.delegate = self;
    self.settingsPopoverController = popController;
    
    [self.settingsPopoverController presentPopoverFromRect:sender.frame
                                            inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    [settingsView updateStrokeWidthUI:self.drawingView.strokeWidth];

}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
//    self.settingsPopoverController = nil;
}

/*
 *  Respond to drawing upload action.
 */
- (IBAction)uploadDrawing:(id)sender {
    
    // Get the image as NSData.
    NSData *imageData = [self.drawingView getImageData];

    // Check if we're linked to DropBox. If not, start the linking
    // process.
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:self];
    }
    
    // Tell the client to create a folder (errors get ignored by default,
    // should the folder already exist.
    [self.restClient createFolder:@"expresso"];
    
    // Get today's date, and format it into the filename, concactinating with "-upload.png".
    NSDate *today = [NSDate date];
    NSDateFormatter *dFormatter = [[NSDateFormatter alloc] init];
    [dFormatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    NSString *fileName = [NSString stringWithFormat:@"%@-upload.png", [dFormatter stringFromDate:today]];
    
    // Put the image in a temp directory so we can upload it.
    NSString *tempDir = NSTemporaryDirectory();
    NSString *imagePath = [tempDir stringByAppendingPathComponent:fileName];
    [imageData writeToFile:imagePath atomically:YES];
    
    // Upload image.
    [self.restClient uploadFile:fileName toPath:@"/expresso" withParentRev:@"" fromPath:imagePath];
    
    [self showProgressView];
    
}

/*
 *  Fade in the little progress view and animate it.
 */
- (void)showProgressView {
    self.progressView.alpha = 0;
    self.progressView.hidden = NO;
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [self.progressView turnGears];
    [UIView animateWithDuration:0.3 animations:^{
        self.progressView.alpha = 1;
    }];
}

/*
 *  Tell the progress view to stop animating and fade it out.
 */
- (void)hideProgressView {
    [UIView animateWithDuration:0.3 animations:^{
        self.progressView.alpha = 0;
    } completion: ^(BOOL finished) {
        self.progressView.hidden = YES;
    }];
    [self.progressView stopGears];
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

/*
 *  DropBox API method -- called when the status of the upload
 *  changes. We essentially ignore the event unless we're 99%
 *  or greater done, then we call it done and hide the progress
 *  indicator.
 */
- (void)restClient:(DBRestClient *)client
    uploadProgress:(CGFloat)progress
           forFile:(NSString *)destPath
              from:(NSString *)srcPath {
    
    if(progress>0.99) {
        [self hideProgressView];
        // Clear drawing.
        [self.drawingView eraseView];
    }
}

@end
