//
//  EXDrawingViewController.m
//  Expresso
//
//  Created by Josef Lange on 3/8/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import "EXDrawingViewController.h"
#import "EXVerificationViewController.h"
#import "EXDrawing.h"
#import "MBProgressHUD.h"

@interface EXDrawingViewController ()

@property (strong, nonatomic) EXDrawing *drawing;
@property (readwrite, nonatomic) MBProgressHUD *hud;

@end

@implementation EXDrawingViewController

@synthesize nextButton = _nextButton;
@synthesize popCon = _popCon;
@synthesize drawing = _drawing;
@synthesize undoManager = _undoManager;
@synthesize session = _session;
@synthesize hud = _hud;

- (EXDrawing *)drawing {
    if(!_drawing) { _drawing = [[EXDrawing alloc] init]; }
    return _drawing;
}

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
    
    self.drawingView.drawingViewDelegate = self;
    self.sessionLabel.text = self.session.sessionIdentifier;
    
    NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
    
    self.undoManager = [[NSUndoManager alloc] init];
    [self.undoManager setLevelsOfUndo:10];
    
    [dnc addObserver:self
            selector:@selector(undoManagerDidUndo:)
                name:NSUndoManagerDidUndoChangeNotification
              object:self.undoManager];
    
    [dnc addObserver:self
            selector:@selector(undoManagerDidRedo:)
                name:NSUndoManagerDidRedoChangeNotification
              object:self.undoManager];
    
    [self updateUndoRedoButtons];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Set the session property in the new ViewController.
    EXVerificationViewController *destinationViewController = segue.destinationViewController;
    destinationViewController.session = self.session;
}

- (IBAction)recognizeDrawing:(id)sender {
    self.nextButton.enabled = NO;
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.labelText = @"Creating expression...";
    [self.session getNewExpressionFrom:self];
}

- (void)receiveNewExpression:(ASIHTTPRequest *)request {
    
    EXExpression *newExpression = [[EXExpression alloc] init];
    
    NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:request.responseData
                                                                 options:NSJSONReadingAllowFragments
                                                                   error:nil];
    
    newExpression.expressionIdentifier = [responseData valueForKey:@"expression_identifier"];

    // Fill in newExpression with the response data.
    [self.session addExpression:newExpression];
    
    [self uploadImage];
}


- (void)newExpressionFailed:(ASIHTTPRequest *)request {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Creation Failed" message:@"Could not create a new expression with Barista." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Try again", nil];
    [alert show];
}

- (void)uploadImage {
    UIImage *renderedImage = [self.drawing renderedImage];
    self.hud.mode = MBProgressHUDModeAnnularDeterminate;
    self.hud.labelText = @"Uploading drawing...";
    [self.session uploadImage:renderedImage from:self]; // Add progress view.
}

- (void)setProgress:(float)newProgress {
    // Intercept setProgress to catch that nasty NaN that comes out of ASIHTTPRequest.
    if(newProgress != newProgress || newProgress<self.hud.progress) {
        self.hud.progress = 1.0;
    } else {
        self.hud.progress = newProgress;
    }
}

- (void)imageUploadFinished:(ASIHTTPRequest *)request {
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.labelText = @"Recognizing Symbols...";
    [self.session getSymbolsFrom:self];
}

- (void)imageUploadFailed:(ASIHTTPRequest *)request {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Image Upload Failed" message:@"Barista didn't like your drawing." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Try again", nil];
    [alertView show];
}

- (void)receiveSymbols:(ASIHTTPRequest *)request {
    NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:request.responseData
                                                                 options:NSJSONReadingAllowFragments
                                                                   error:nil];
    NSArray *symbols = [responseData valueForKey:@"symbols"];
    [self.session.currentExpression setSymbolsWithArrayOfDicts:symbols];
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

    [self advanceToProcess];
}

- (void)symbolsFailed:(ASIHTTPRequest *)request {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Could not receive symbols" message:@"Barista wasn't able to make sense of your drawing." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Try again", nil];
    [alertView show];
}

- (void)advanceToProcess {
    self.nextButton.enabled = YES;
    [self performSegueWithIdentifier:@"DrawingToRecognition" sender:self];
}

- (void)drawingDidEnd:(UIBezierPath *)path {
    [self.drawing addPath:[path copy]];
    [self.undoManager registerUndoWithTarget:self
                                    selector:@selector(removeMostRecentDraw)
                                      object:nil];
        
    self.undoButton.enabled = [self.undoManager canUndo];
    self.redoButton.enabled = [self.undoManager canRedo];
}

- (void)removeMostRecentDraw {
    UIBezierPath *path = [self.drawing removeMostRecentPath];
    [self.undoManager registerUndoWithTarget:self
                                    selector:@selector(drawingDidEnd:)
                                      object:path];
    
}

- (void)undoManagerDidUndo:(NSUndoManager *)undoManager {
    [self.drawingView redrawFromPaths:self.drawing.drawnPaths];
    [self.drawingView setNeedsDisplay];
    [self updateUndoRedoButtons];
}

- (void)undoManagerDidRedo:(NSUndoManager *)undoManager {
    [self.drawingView redrawFromPaths:self.drawing.drawnPaths];
    [self.drawingView setNeedsDisplay];
    [self updateUndoRedoButtons];
}

- (void)updateUndoRedoButtons {
    self.undoButton.enabled = [self.undoManager canUndo];
    self.redoButton.enabled = [self.undoManager canRedo];
}

-(IBAction)undo:(id)sender {
    [self.undoManager undo];
}

-(IBAction)redo:(id)sender {
    [self.undoManager redo];
}

-(IBAction)clearDrawing:(id)sender {
    [self.drawing clearPaths];
    [self.drawingView redrawFromPaths:self.drawing.drawnPaths];
    [self.drawingView setNeedsDisplay];
    [self.undoManager removeAllActions];
    [self updateUndoRedoButtons];
    
}


- (IBAction)showSettings:(id)sender {
    EXDrawSettingsViewController *settingsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DrawSettings"];
    if([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
        // Show settings iPhone way.
        [settingsViewController setModalTransitionStyle:UIModalTransitionStylePartialCurl];
        [self presentModalViewController:settingsViewController animated:YES];
    } else {
        if(!self.popCon) {
            // Show settings iPad way.
            self.popCon = [[UIPopoverController alloc] initWithContentViewController:settingsViewController];
            settingsViewController.myPopoverController = self.popCon;
            [self.popCon setDelegate:self];
            [self.popCon presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            self.settingsButton.enabled = NO;
        }
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    self.popCon = nil;
    self.settingsButton.enabled = YES;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            // Do nothing.
            self.nextButton.enabled = YES;
            break;
        case 1:
            // Try again.
            [self recognizeDrawing:self];
        default:
            // Do nothing.
            break;
    }
}


@end
