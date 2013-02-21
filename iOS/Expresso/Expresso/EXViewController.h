//
//  EXViewController.h
//  Expresso
//
//  (CONTROLLER)
//
//  This is the main root controller for the application. It manages the drawing model, the drawing
//  view, and all controls on the main view, including the presentation of the UIPopover that
//  contains the application's settings. It also manages, through an NSUndoManager, undo and redo
//  of drawing.
//
//  Created by Josef Lange on 2/21/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EXDrawingView.h"

@interface EXViewController : UIViewController <UIPopoverControllerDelegate, EXDrawingViewDelegate>

@property (weak, nonatomic) IBOutlet EXDrawingView *drawingView; // The drawing View.
@property (weak, nonatomic) IBOutlet UIButton *undoButton;
@property (weak, nonatomic) IBOutlet UIButton *redoButton;

@property (retain) NSUndoManager *undoManager; // The undo manager we're going to use here.

-(IBAction)undo:(id)sender;
-(IBAction)redo:(id)sender;
-(IBAction)clearDrawing:(id)sender;
-(IBAction)showOptions:(UIButton *)sender; // Presents UIPopover for EXDrawSettingsViewController.


@end
