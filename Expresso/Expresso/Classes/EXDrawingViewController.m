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

/** The drawing we're looking at, lazily instantiated. */
@property (strong, nonatomic) EXDrawing *drawing;

/** The progress HUD that displays when necessary. */
@property (readwrite, nonatomic) MBProgressHUD *hud;

@end

@implementation EXDrawingViewController

@synthesize nextButton = _nextButton;
@synthesize popCon = _popCon;
@synthesize drawing = _drawing;
@synthesize undoManager = _undoManager;
@synthesize session = _session;
@synthesize hud = _hud;

#pragma mark - Property Instantiation

- (EXDrawing *)drawing {
    if(!_drawing) { _drawing = [[EXDrawing alloc] init]; }
    return _drawing;
}

- (NSUndoManager *)undoManager {
    if(!_undoManager) { _undoManager = [[NSUndoManager alloc] init]; }
    return _undoManager;
}

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

#pragma mark - View Lifecycle

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
 *  Setup for when the view loads.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Get background image and set it to the background.
    UIImage *fibers = [UIImage imageNamed:@"paper_fibers"];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:fibers]];
    
    // Set up self as the delegate for the EXDrawingView.
    self.drawingView.drawingViewDelegate = self;
    
    // Set our session label as the session's actual label.
    self.sessionLabel.text = self.session.sessionIdentifier;
    
    // Create the undo manager.
    [self.undoManager setLevelsOfUndo:10];
    
    // Get the default NSNotificationCenter so we can register ourself as
    // the undo responder.
    NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
    
    
    [dnc addObserver:self
            selector:@selector(undoManagerDidUndo:)
                name:NSUndoManagerDidUndoChangeNotification
              object:self.undoManager];
    
    [dnc addObserver:self
            selector:@selector(undoManagerDidRedo:)
                name:NSUndoManagerDidRedoChangeNotification
              object:self.undoManager];
    
    // Update the undo and redo buttons.
    [self updateUndoRedoButtons];
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.nextButton.enabled = YES;
}

/**
 *  Stub for overriding.
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Expression / Image / Symbol Request & Handling

// (Documented in header file)
- (IBAction)recognizeDrawing:(id)sender {
    
    // Disable next button.
    self.nextButton.enabled = NO;
    
    // Create, configure, and show HUD.
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.labelText = @"Creating expression...";
    
    // Start request for new expression from API.
    [self.session getNewExpressionFrom:self];
    
}

// (Documented in header file)
- (void)receiveNewExpression:(ASIHTTPRequest *)request {
    
    if(request.responseStatusCode==500 || request.responseStatusCode==404) {
        
        [self newExpressionFailed:request];
        
    } else {
    
        // Make an empty expression object.
        EXExpression *newExpression = [[EXExpression alloc] init];
        
        // Get response data.
        NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:request.responseData
                                                                     options:NSJSONReadingAllowFragments
                                                                       error:nil];
        // Fill in data from response to the object.
        newExpression.expressionIdentifier = [responseData valueForKey:@"expression_identifier"];

        // Add the expression to the session.
        [self.session addExpression:newExpression];
        
        // Issue message to upload the image.
        [self uploadImage];
        
    }
}


// (Documented in header file)
- (void)newExpressionFailed:(ASIHTTPRequest *)request {
    // Create a UIAlertView.
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Expression Creation Failure" message:@"Could not create a new expression with Barista." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Try again", nil];
    // Show the alert view.
    [alert show];
}

// (Documented in header file)
- (void)uploadImage {
    
    // Get rendered image.
    UIImage *renderedImage = [self.drawing renderedImage];
    
    // Change the HUD mode.
    self.hud.mode = MBProgressHUDModeAnnularDeterminate;
    self.hud.labelText = @"Uploading drawing...";
    
    // Request POST to API the image.
    [self.session uploadImage:renderedImage from:self];
    
}

// (Documented in header file)
- (void)setProgress:(float)newProgress {
    
    // If newProgress is NaN or less than the currently-set progress, set to 1.0,
    // otherwise pass through to the HUD.
    if(newProgress != newProgress || newProgress<self.hud.progress) {
        self.hud.progress = 1.0;
    } else {
        self.hud.progress = newProgress;
    }
    
}

// (Documented in header file)
- (void)imageUploadFinished:(ASIHTTPRequest *)request {
    
    if(request.responseStatusCode==404 || request.responseStatusCode==500) {
        
        [self imageUploadFailed:request];
        
    } else {
    
        // Change HUD mode.
        self.hud.mode = MBProgressHUDModeIndeterminate;
        self.hud.labelText = @"Recognizing Symbols...";
        
        // Get symbols!
        [self.session getSymbolsFrom:self];
        
    }
    
}

// (Documented in header file)
- (void)imageUploadFailed:(ASIHTTPRequest *)request {
    
    // Create a UIAlertView.
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Image Upload Failed" message:@"Your drawing failed to upload to Barista." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Try again", nil];
    // Show the UIAlertView.
    [alertView show];
    
}

// (Documented in header file)
- (void)receiveSymbols:(ASIHTTPRequest *)request {
    
    if(request.responseStatusCode==404 || request.responseStatusCode==500) {
        
        [self symbolsFailed:request];
        
    } else {
        
        // Get Dictionary of the data.
        NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:request.responseData
                                                                     options:NSJSONReadingAllowFragments
                                                                       error:nil];
        // Pull the symbols out of the data.
        NSArray *symbols = [responseData valueForKey:@"symbols"];
        
        // Set the current expression's symbols array to the response symbols.
        [self.session.currentExpression setSymbolsWithArrayOfDicts:symbols];
        
        // Hide all HUDs.
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        // Perform the segue to go to the recognition view.
        [self performSegueWithIdentifier:@"DrawingToRecognition" sender:self];
        
    }
}

// (Documented in header file)
- (void)symbolsFailed:(ASIHTTPRequest *)request {
    
    // Create a UIAlertView.
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Symbols Not Returned" message:@"Barista wasn't able to make sense of your drawing, for some reason or another." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Try again", nil];
    // Show the UIAlertView.
    [alertView show];
    
}

# pragma mark - Drawing View Delegate Protocol

/**
 *  Delegate method from EXDrawingView that allows us to put the most recent path
 *  in the EXDrawing object and register undo/redo stuff.
 *
 *  @param  path    The path that was just drawn.
 *
 */
- (void)drawingDidEnd:(UIBezierPath *)path {
    
    // Add a copy of the path to self.drawing.
    [self.drawing addPath:[path copy]];
    
    // Register the undo for it.
    [self.undoManager registerUndoWithTarget:self
                                    selector:@selector(removeMostRecentDraw)
                                      object:nil];
    // Update undo and redo buttons.
    [self updateUndoRedoButtons];
}

#pragma mark - Undo/Redo Methods

// (Documented in header file)
-(IBAction)undo:(id)sender {
    [self.undoManager undo];
}


// (Documented in header file)
-(IBAction)redo:(id)sender {
    [self.undoManager redo];
}

/**
 *  Undo Manager notification response to when we did undo.
 *
 *  @param  undoManager The NSUndoManager that did undo.
 */
- (void)undoManagerDidUndo:(NSUndoManager *)undoManager {
    
    // Redraw the drawing with our new state.
    [self.drawingView redrawFromPaths:self.drawing.drawnPaths];
    [self.drawingView setNeedsDisplay];
    
    // Update undo/redo buttons.
    [self updateUndoRedoButtons];
    
}

/**
 *  Undo Manager notification response to when we did redo.
 *
 *  @param  undoManager The NSUndoManager that did redo.
 */
- (void)undoManagerDidRedo:(NSUndoManager *)undoManager {
    
    // Redraw the drawing with our new state.
    [self.drawingView redrawFromPaths:self.drawing.drawnPaths];
    [self.drawingView setNeedsDisplay];
    
    // Update the undo.redo buttons.
    [self updateUndoRedoButtons];
    
}

/**
 *  Pop off most recent path from self.drawing and register **its** undo as a drawingDidEnd: call.
 */
- (void)removeMostRecentDraw {
    UIBezierPath *path = [self.drawing removeMostRecentPath];
    [self.undoManager registerUndoWithTarget:self
                                    selector:@selector(drawingDidEnd:)
                                      object:path];
    
}

/**
 *  Update undo and redo buttons based on information from the undo manager.
 */
- (void)updateUndoRedoButtons {
    self.undoButton.enabled = [self.undoManager canUndo];
    self.redoButton.enabled = [self.undoManager canRedo];
}

#pragma mark - IBActions

// (Documented in header file)
-(IBAction)clearDrawing:(id)sender {
    [self.drawing clearPaths];
    [self.drawingView redrawFromPaths:self.drawing.drawnPaths];
    [self.drawingView setNeedsDisplay];
    [self.undoManager removeAllActions];
    [self updateUndoRedoButtons];
    
}

// (Documented in header file)
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

/**
 *  Pass the session forward.
 *
 *  @param  segue   The segue about to happen.
 *  @param  sender  The message sender.
 */

#pragma mark - Segue Handling

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    EXVerificationViewController *destinationViewController = segue.destinationViewController;
    destinationViewController.session = self.session;
}

#pragma mark - Popover Delegate Protocol

/**
 *  UIPopoverController delegate method. Respond to the popover going bye-bye.
 *
 *  @param  popoverController   The PopoverController that dismissed the popover.
 */
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    
    // Nil out the pointer to the popover controller.
    self.popCon = nil;
    
    // Re-enable settings button.
    self.settingsButton.enabled = YES;
    
}

#pragma mark - Alert View Delegate Protocol

/**
 *  Respond to UIAlertView that gets called up in the event of any network errors.
 *
 *  @param  alertView   The alert view that was dismissed.
 *  @param  buttonIndex The index of the button pressed to dismiss the alert view.
 */
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            // Do nothing.
            self.nextButton.enabled = YES;
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            break;
        case 1:
            // Try again.
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self recognizeDrawing:self];
        default:
            // Do nothing.
            break;
    }
}


@end
