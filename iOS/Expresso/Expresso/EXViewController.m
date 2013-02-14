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

@synthesize restClient = _restClient;

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortrait);
}

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

- (void)viewDidUnload {
    [self setMainView:nil];
    [self setDrawingView:nil];
    [self setStrokeWidthSlider:nil];
    [self setStrokeWidthLabel:nil];
    [super viewDidUnload];
}
- (IBAction)strokeWidthChanged:(UISlider *)sender {
    NSNumber *newValue = [NSNumber numberWithFloat:sender.value];
    NSNumber *newValueInt = [NSNumber numberWithInt:[newValue intValue]];
    self.drawingView.strokeWidth = newValueInt;
    self.strokeWidthLabel.text = [NSString stringWithFormat:@"Stroke Width: %d",
                                  [newValueInt intValue]];
}
- (IBAction)clearDrawing:(id)sender {
    [self.drawingView eraseView];
}

- (DBRestClient *)restClient {
    if (!_restClient) {
        _restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        _restClient.delegate = self;
    }
    return _restClient;
}

- (IBAction)uploadDrawing:(id)sender {
    
    NSData *imageData = [self.drawingView getImageData];

    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:self];
    }
    
    [self.restClient createFolder:@"expresso"];
    
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dFormatter = [[NSDateFormatter alloc] init];
    [dFormatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    NSString *fileName = [NSString stringWithFormat:@"%@-upload.png", [dFormatter stringFromDate:today]];
    NSString *tempDir = NSTemporaryDirectory();
    NSString *imagePath = [tempDir stringByAppendingPathComponent:fileName];
    [imageData writeToFile:imagePath atomically:YES];
    [self.restClient uploadFile:fileName toPath:@"/expresso" fromPath:imagePath];
 
    [self clearDrawing:sender];
    
}

@end
