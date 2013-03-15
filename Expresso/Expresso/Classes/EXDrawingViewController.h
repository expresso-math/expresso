//
//  EXDrawingViewController.h
//  Expresso
//
//  Created by Josef Lange on 3/8/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EXSession.h"
#import "EXDrawSettingsViewController.h"
#import "EXDrawingView.h"

/**
 *  The view controller for the drawing view. Manages the drawing undo stack, as well as
 *  the settings popover and uploading of the drawing to Barista.
 */

@interface EXDrawingViewController : UIViewController <UIPopoverControllerDelegate, EXDrawingViewDelegate, UIAlertViewDelegate>

/** The popover controller for settings display on iPad. */
@property (strong, nonatomic) UIPopoverController *popCon;

/** The current EXSession with Barista. */
@property (strong, nonatomic) EXSession *session;

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

/** The UILabel object to show our session_identifier. */
@property (weak, nonatomic) IBOutlet UILabel *sessionLabel;

/** The NSUndoManager that is going to manage the drawing view's undo stack. */
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
- (IBAction)recognizeDrawing:(id)sender;

/**
 *  Receive the request once it's successfully been made. Extract the expression
 *  from the response, and start the image upload.
 *
 *  @param request The completed request.
 */
- (void)receiveNewExpression:(ASIHTTPRequest *)request;

/**
 *  Expression request has failed. Handle its failure (notify user, halt current
 *  process of upload, etc.
 *
 *  @param request The failed request.
 */
- (void)newExpressionFailed:(ASIHTTPRequest *)request;

/**
 *  Receive the request for symbols once it's successfully been made. Extract the symbols
 *  from the response and move forward to show them.
 *
 *  @param request The completed request.
 */
- (void)receiveSymbols:(ASIHTTPRequest *)request;


/**
 *  Symbol request has failed. Handle its failure (notify user, halt current
 *  process of moving forward, etc.
 *
 *  @param request The failed request.
 */
- (void)symbolsFailed:(ASIHTTPRequest *)request;

@end
