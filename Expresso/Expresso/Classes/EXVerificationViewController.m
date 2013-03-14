//
//  EXVerificationViewController.m
//  Expresso
//
//  Created by Josef Lange on 3/8/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import "EXVerificationViewController.h"
#import "EXSymbolView.h"

@interface EXVerificationViewController ()

@end

@implementation EXVerificationViewController

@synthesize nextButton = _nextButton;
@synthesize session = _session;
@synthesize boundingBoxes = _boundingBoxes;
@synthesize imageView = _imageView;

/**
 *  Lazy instantiation for boundingBoxes.
 */
- (NSArray *)boundingBoxes {
    if(!_boundingBoxes) {
        _boundingBoxes = [[NSArray alloc] init];
    }
    return _boundingBoxes;
}

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

/**
 *  Override for setting up a simple BOOL flag on load.
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.boundingBoxesShowing = NO;
    }
    return self;
}

/**
 *  Override stub.
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
}

/**
 *  Override to do some stuff when the view's about to appear.
 *
 *  Goes through the current expression and gets its data -- image,
 *  symbols; and fills in little SymbolViews with the appropriate data
 *  so they can overlay the image.
 *
 *  @param animated Whether or not we should animate.
 */
- (void)viewWillAppear:(BOOL)animated {
    
    // Get the size of the image, fit to the view.
    self.imageView.image = self.session.currentExpression.image;
    [self.imageView sizeToFit];

    EXSymbol *symbol;
	// Do any additional setup after loading the view.
    for (symbol in self.session.currentExpression.symbols) {
        EXSymbolView *newView = [[EXSymbolView alloc] initWithFrame:symbol.boundingBox];
        newView.delegate = self;
        newView.symbol = symbol;
        self.boundingBoxes = [self.boundingBoxes arrayByAddingObject:newView];
    }
    
    // Show our bounding boxes.
    [self showBoundingBoxes];
   
}

/**
 *  Target action for a symbol being selected by the user.
 *
 *  @param sender   The sender of the message.
 */
- (void)symbolSelected:(id)sender {
    if( [sender class] == [EXSymbolView class] ) {
        EXSymbolView *view = (EXSymbolView *)sender;
        [self displayEditingDialogWithSymbolView:view];
    } else {
        [NSException raise:@"Non-EXSymbolView sent symbolSelected." format:@"Thrower was actually of class %@.", [sender class]];
    }
}

/**
 *  Stub for displaying the edit window for a given symbolView and its symbol.
 *
 *  @param  view    The view whose symbol we should modify with this dialog.
 */
- (void)displayEditingDialogWithSymbolView:(EXSymbolView *)view {
    // Do something here to display the editing dialog. Have to decide what that's going to look like...
    NSLog(@"SymbolView %@ wants to be edited.", view);
}

/**
 *  Stub for overriding.
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  Uh, toggle the bounding boxes.
 *
 *  @param  sender  The message sender.
 */
- (IBAction)toggleBoundingBoxes:(id)sender {
    if(self.boundingBoxesShowing) {
        [self hideBoundingBoxes];
    } else {
        [self showBoundingBoxes];
    }
}

/**
 *  Go through the symbolViews and show them.
 */
- (void)showBoundingBoxes {
    EXSymbolView *view;
    for (view in self.boundingBoxes) {
        [UIView transitionWithView:self.view duration:0.2
                           options:UIViewAnimationOptionTransitionCrossDissolve //change to whatever animation you like
                        animations:^ { [self.view addSubview:view]; }
                        completion:nil];
    }
    self.boundingBoxesShowing = YES;
}

/**
 *  Go through the symbolViews and hide them.
 */
- (void)hideBoundingBoxes {
    EXSymbolView *view;
    for (view in self.boundingBoxes) {
        [UIView transitionWithView:self.view duration:0.2
                           options:UIViewAnimationOptionTransitionCrossDissolve //change to whatever animation you like
                        animations:^ { [view removeFromSuperview]; }
                        completion:nil];
    }
    self.boundingBoxesShowing = NO;
    
}

/**
 *  Rocket the user back to the Welcome View.
 *
 *  @param  sender  The message sender.
 */
- (IBAction)startOver:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
