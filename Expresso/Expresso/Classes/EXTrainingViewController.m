//
//  EXTrainingViewController.m
//  Expresso
//
//  Created by Josef Lange on 3/18/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import "EXTrainingViewController.h"
#import "EXDrawSettingsViewController.h"
#import "EXDrawing.h"
#import "EXSession.h"
#import "MBProgressHUD.h"

@interface EXTrainingViewController ()

/** The drawing we're looking at, lazily instantiated. */
@property (strong, nonatomic) EXDrawing *drawing;

/** The progress HUD that displays when necessary. */
@property (readwrite, nonatomic) MBProgressHUD *hud;

/** The symbol we're training on currently. */
@property (strong, nonatomic) NSString *symbol;

@end

@implementation EXTrainingViewController

@synthesize nextButton = _nextButton;
@synthesize popCon = _popCon;
@synthesize drawing = _drawing;
@synthesize undoManager = _undoManager;
@synthesize hud = _hud;
@synthesize symbol = _symbol;

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
 *  Setup for when the view loads.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Get background image and set it to the background.
    UIImage *fibers = [UIImage imageNamed:@"paper_fibers"];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:fibers]];
    
    // Set up self as the delegate for the EXDrawingView.
    self.drawingView.drawingViewDelegate = self;
    
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
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.drawingView animated:YES];
    self.hud.animationType = MBProgressHUDAnimationZoom;
    
    [self getNewSymbol];
    
}

// Documented in header file.
- (void)startOver {
    self.nextButton.enabled = YES;
    [self clearDrawing:self];
    [self getNewSymbol];
}

#pragma mark - Training Symbol Management

/**
 *  Get a new symbol from the API for training.
 *
 */
-(void)getNewSymbol {
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.labelText = @"Retrieving Training Data";
    
    [self.hud show:YES];
    
    self.symbol = [EXSession getSymbolForTraining];
    
    [self.hud hide:YES];
    
    UIAlertView *prompt = [[UIAlertView alloc] initWithTitle:@"Training" message:[NSString stringWithFormat:@"Please draw as many \"%@\" symbols as you can fit.", self.symbol] delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    [prompt show];
}

#pragma mark - Handling Finished Drawing
-(IBAction)sendTrainingSet:(id)sender {
    
    // Get rendered image.
    UIImage *renderedImage = [self.drawing renderedImage];
    
    self.nextButton.enabled = NO;
    
    // Change the HUD mode.
    self.hud.mode = MBProgressHUDModeAnnularDeterminate;
    self.hud.labelText = @"Uploading drawing...";
    
    [self.hud show:YES];
    [EXSession uploadTrainingImage:renderedImage forSymbol:self.symbol from:self];
}

// Documented in header file.
-(void)imageUploaded:(ASIHTTPRequest *)request {
    [self.hud hide:YES];
    [self startOver];
}

#pragma mark - Drawing View Delegate Protocol

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

#pragma mark - HUD Intercept
-(void)setProgress:(float)newProgress {
    // If newProgress is NaN or less than the currently-set progress, set to 1.0,
    // otherwise pass through to the HUD.
    if(newProgress != newProgress || newProgress<self.hud.progress) {
        self.hud.progress = 1.0;
    } else {
        self.hud.progress = newProgress;
    }
}

#pragma mark - UIAlertView Delegate Protocol
-(void)alertViewCancel:(UIAlertView *)alertView {
    // Do nothing, probably.
}

@end
