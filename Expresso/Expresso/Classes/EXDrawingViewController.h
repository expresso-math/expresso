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

@interface EXDrawingViewController : UIViewController <UIPopoverControllerDelegate, EXDrawingViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) UIPopoverController *popCon;
@property (strong, nonatomic) EXSession *session;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *settingsButton;
@property (weak, nonatomic) IBOutlet EXDrawingView *drawingView; // The drawing View.
@property (weak, nonatomic) IBOutlet UIBarButtonItem *undoButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *redoButton;
@property (weak, nonatomic) IBOutlet UILabel *sessionLabel;

@property (retain) NSUndoManager *undoManager; // The undo manager we're going to use here.

- (IBAction)undo:(id)sender;
- (IBAction)redo:(id)sender;
- (IBAction)clearDrawing:(id)sender;
- (IBAction)showSettings:(id)sender;
- (IBAction)recognizeDrawing:(id)sender;
- (void)receiveNewExpression:(ASIHTTPRequest *)request;
- (void)newExpressionFailed:(ASIHTTPRequest *)request;
- (void)advanceToProcess;

@end
