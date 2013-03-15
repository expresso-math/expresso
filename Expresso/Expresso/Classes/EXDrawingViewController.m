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

#pragma mark - Property Instantiation

/**
 *  Lazy instantiation for drawing.
 *
 *  @return The drawing.
 */
- (EXDrawing *)drawing {
    if(!_drawing) { _drawing = [[EXDrawing alloc] init]; }
    return _drawing;
}

/**
 *  Lazy instantiation for undoManager.
 *
 *  @return The NSUndoManager.
 */
- (NSUndoManager *)undoManager {
    if(!_undoManager) { _undoManager = [[NSUndoManager alloc] init]; }
    return _undoManager;
}

#pragma mark - Screen Orientation

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

#pragma mark - View Lifecycle

/**
 *  Stub for overriding.
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

/**
 *  Stub for overriding.
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Expression / Image / Symbol Request & Handling

/**
 *  Respond to the "Recognize" button.
 *
 *  @param  sender  The message sender.
 */
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

/**
 *  Delegate method called by ASIHTTPRequest when a new expression request has completed.
 *
 *  @param  request The request that has completed.
 */
- (void)receiveNewExpression:(ASIHTTPRequest *)request {
    
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


/**
 *  Delegate method called by ASIHTTPRequest when a new expression request has failed.
 *
 *  @param  request The request that has failed.
 */
- (void)newExpressionFailed:(ASIHTTPRequest *)request {
    // Create a UIAlertView.
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Creation Failed" message:@"Could not create a new expression with Barista." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Try again", nil];
    // Show the alert view.
    [alert show];
}

/**
 *  Upload the image to the API. API assumes you mean most recent expression.
 */
- (void)uploadImage {
    
    // Get rendered image.
    UIImage *renderedImage = [self.drawing renderedImage];
    
    // Change the HUD mode.
    self.hud.mode = MBProgressHUDModeAnnularDeterminate;
    self.hud.labelText = @"Uploading drawing...";
    
    // Request POST to API the image.
    [self.session uploadImage:renderedImage from:self];
    
}

/**
 *  Get setProgress from ASIHTTPRequest (FormRequest or something), so we can
 *  clean up its values before sending them on to our HUD.
 *
 *  @param  newProgress floating-point number representing progress (0.0 - 0.1).
 */
- (void)setProgress:(float)newProgress {
    
    // If newProgress is NaN or less than the currently-set progress, set to 1.0,
    // otherwise pass through to the HUD.
    if(newProgress != newProgress || newProgress<self.hud.progress) {
        self.hud.progress = 1.0;
    } else {
        self.hud.progress = newProgress;
    }
    
}

/**
 *  Delegate method called by ASIHTTPRequest when an image post has completed.
 *
 *  @param  request The request/post that has completed.
 */
- (void)imageUploadFinished:(ASIHTTPRequest *)request {
    
    // Change HUD mode.
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.labelText = @"Recognizing Symbols...";
    
    // Get symbols!
    [self.session getSymbolsFrom:self];
    
}

/**
 *  Delegate method called by ASIHTTPRequest when an image post has failed.
 *
 *  @param  request The request/post that has failed.
 */
- (void)imageUploadFailed:(ASIHTTPRequest *)request {
    
    // Create a UIAlertView.
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Image Upload Failed" message:@"Barista didn't like your drawing." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Try again", nil];
    // Show the UIAlertView.
    [alertView show];
    
}

/**
 *  Delegate method called by ASIHTTPRequest when a symbol set request has completed.
 *
 *  @param  request The request that has completed.
 */
- (void)receiveSymbols:(ASIHTTPRequest *)request {
    
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

/**
 *  Delegate method called by ASIHTTPRequest when a symbol set request has failed.
 *
 *  @param  request The request that has failed.
 */
- (void)symbolsFailed:(ASIHTTPRequest *)request {
    
    // Create a UIAlertView.
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Could not receive symbols" message:@"Barista wasn't able to make sense of your drawing." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Try again", nil];
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

/**
 *  Respond to undo button.
 *
 *  @param  sender  The message sender.
 */
-(IBAction)undo:(id)sender {
    [self.undoManager undo];
}


/**
 *  Respond to redo button.
 *
 *  @param  sender  The message sender.
 */
-(IBAction)redo:(id)sender {
    [self.undoManager redo];
}

/**
 *  Undo Manager notification response to when we did undo.
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

/**
 *  Respond to the clear drawing sender by, well, clearing the drawing.
 *
 *  @param  sender  The message sender.
 */
-(IBAction)clearDrawing:(id)sender {
    [self.drawing clearPaths];
    [self.drawingView redrawFromPaths:self.drawing.drawnPaths];
    [self.drawingView setNeedsDisplay];
    [self.undoManager removeAllActions];
    [self updateUndoRedoButtons];
    
}

/**
 *  Display settings view. Modal (page curl) on iPhone, or popover on iPad.
 *
 *  @param sender The sender.
 */
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
