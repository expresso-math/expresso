//
//  EXViewController.m
//  Expresso
//
//  Created by Josef Lange on 2/21/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import "EXViewController.h"
#import "EXDrawing.h"
#import "EXDrawSettingsViewController.h"
#import "EXRecognitionVerificationViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <RestKit/RestKit.h>
#import "UIButton+Glossy.h"

@interface EXViewController ()

@property (strong, nonatomic) EXDrawing *drawing;

@end

@implementation EXViewController

@synthesize drawing = _drawing;
@synthesize drawingView = _drawingView;
@synthesize undoManager = _undoManager;

/*
 *  Help force landscape.
 */
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortrait);
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
    
    self.undoManager = [[NSUndoManager alloc] init];
    [self.undoManager setLevelsOfUndo:10];
    
    [dnc addObserver:self selector:@selector(undoManagerDidUndo:) name:NSUndoManagerDidUndoChangeNotification object:self.undoManager];
    [dnc addObserver:self selector:@selector(undoManagerDidRedo:) name:NSUndoManagerDidRedoChangeNotification object:self.undoManager];
    
    [self updateUndoRedoButtons];
    
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self resignFirstResponder];
}

- (EXDrawing *)drawing {
    if(!_drawing) { _drawing = [[EXDrawing alloc] init]; }
    return _drawing;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [self.undoManager registerUndoWithTarget:self selector:@selector(drawingDidEnd:) object:path];

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

-(IBAction)showOptions:(UIBarButtonItem *)sender {
    EXDrawSettingsViewController *drawSettingsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"drawSettings"];
    
//    drawSettingsViewController.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIPopoverController *popController = [[UIPopoverController alloc] initWithContentViewController:drawSettingsViewController];
    
    drawSettingsViewController.popoverController = popController;
    drawSettingsViewController.popoverController.delegate = self;
    
    [drawSettingsViewController.popoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];

}

-(IBAction)processDrawing:(id)sender {
    // Huh? Maybe nothing.
}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {    
    EXRecognitionVerificationViewController *desinationController = segue.destinationViewController;
    desinationController.image = [self.drawing renderedImage];

    // RestKit object mapping and such.
    RKObjectMapping *objectMapping = [RKObjectMapping mappingForClass:[EXDrawing class]];

}

@end
