//
//  EXViewController.m
//  Expresso
//
//  Created by Josef Lange on 2/6/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import "EXViewController.h"

@interface EXViewController ()

@end

@implementation EXViewController

@synthesize restClient = _restClient; // Synth restClient into an instance variable.

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
    
    [self.mainView setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:1.0]];
    self.strokeWidthSlider.minimumValue = 1.0;
    self.strokeWidthSlider.maximumValue = 10.0;
    self.drawingView.strokeWidth = [NSNumber numberWithInt:3];
    self.strokeWidthSlider.value = 3.0;
    self.strokeWidthLabel.text = @"Stroke Width: 3";
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
    [self setStrokeWidthSlider:nil];
    [self setStrokeWidthLabel:nil];
    [super viewDidUnload];
}

/*
 *  Respond to changing of the stroke width slider. Sets the property in the drawing
 *  view and updates the label next to the slider.
 */
- (IBAction)strokeWidthChanged:(UISlider *)sender {
    NSNumber *newValue = [NSNumber numberWithFloat:sender.value];
    NSNumber *newValueInt = [NSNumber numberWithInt:[newValue intValue]];
    self.drawingView.strokeWidth = newValueInt;
    self.strokeWidthLabel.text = [NSString stringWithFormat:@"Stroke Width: %d",
                                  [newValueInt intValue]];
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
    
    // Clear drawing.
    [self clearDrawing:sender];
    
}

@end
