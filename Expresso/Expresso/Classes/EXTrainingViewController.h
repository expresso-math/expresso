//
//  EXTrainingViewController.h
//  Expresso
//
//  Created by Josef Lange on 3/18/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EXDrawingView.h"
#import "ASIHTTPRequest.h"


/**
 *  The view controller used for training.
 *
 */
@interface EXTrainingViewController : UIViewController <UIPopoverControllerDelegate, EXDrawingViewDelegate, UIAlertViewDelegate>

/** The popover controller for settings display on iPad. */
@property (strong, nonatomic) UIPopoverController *popCon;

/** The button to start upload and segue. */
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton;

/** The button that displays the settings dialog. */
@property (weak, nonatomic) IBOutlet UIBarButtonItem *settingsButton;

/** The drawing view itself. */
@property (weak, nonatomic) IBOutlet EXDrawingView *drawingView;

/** The undo button. */
@property (weak, nonatomic) IBOutlet UIBarButtonItem *undoButton;

/** The redo button. */
@property (weak, nonatomic) IBOutlet UIBarButtonItem *redoButton;

/** The NSUndoManager that is going to manage the drawing view's undo stack, lazily instantiated. */
@property (strong, nonatomic) NSUndoManager *undoManager;

/**
 *  Undo. Just forwards the command to the undoManager.
 *
 *  @param sender The sender.
 */
- (IBAction)undo:(id)sender;

/**
 *  Redo. Just forwards the command to the undoManager.
 *
 *  @param sender The sender.
 */
- (IBAction)redo:(id)sender;

/**
 *  Clear the drawing. Removes paths from private EXDrawing object,
 *  redraws from paths, and resets the undoManager.
 *
 *  @param sender The sender.
 */
- (IBAction)clearDrawing:(id)sender;

/**
 *  Display settings view. Modal (page curl) on iPhone, or popover on iPad.
 *
 *  @param sender The sender.
 */
- (IBAction)showSettings:(id)sender;

/**
 *  Start the recognition process. Really issues command to create a new
 *  expression on Barista's end, then calls receiveNewExpression:
 *
 *  @param sender The sender.
 */
- (IBAction)sendTrainingSet:(id)sender;

/**
 *  Delegate method fired off when the image has been successfully uploaded
 *  to Barista.
 *
 *  @param  request The request that was submitted.
 */
- (void)imageUploaded:(ASIHTTPRequest *)request;

/**
 *  Protocol for intercepting HUD setProgress.
 *
 *  @param  newProgress The new value of progress to set.
 */
- (void)setProgress:(float)newProgress;


/**
 *  Start a new training event.
 *
 */
- (void)startOver;

@end
