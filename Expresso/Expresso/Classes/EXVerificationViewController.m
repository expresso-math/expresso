//
//  EXVerificationViewController.m
//  Expresso
//
//  Created by Josef Lange on 3/8/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//
#import "EXVerificationViewController.h"
#import "EXSymbolCorrectionViewController.h"
#import "EXSymbolView.h"
#import "EXEquation.h"
#import "EXEquationViewController.h"
#import "MBProgressHUD.h"

@interface EXVerificationViewController ()

/** The progress HUD that displays when necessary. */
@property (readwrite, nonatomic) MBProgressHUD *hud;


@end

@implementation EXVerificationViewController

@synthesize nextButton = _nextButton;
@synthesize session = _session;
@synthesize boundingBoxes = _boundingBoxes;
@synthesize imageView = _imageView;
@synthesize sessionLabel = _sessionLabel;
@synthesize pop = _pop;
@synthesize hud = _hud;

#pragma mark - Property Instantiation

- (NSArray *)boundingBoxes {
    if(!_boundingBoxes) {
        _boundingBoxes = [[NSArray alloc] init];
    }
    return _boundingBoxes;
}

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
        self.boundingBoxesShowing = NO;
    }
    return self;
}

/**
 *  Override stub.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated {
    EXSymbolView *view;
    for (view in self.boundingBoxes) {
        [[NSNotificationCenter defaultCenter] removeObserver:view];
    }
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
    
    // Fill in session label.
    self.sessionLabel.text = self.session.sessionIdentifier;
    
    // Get the size of the image, fit to the view.
    self.imageView.image = self.session.currentExpression.image;
    [self.imageView sizeToFit];

    EXSymbol *symbol;
	// Do any additional setup after loading the view.
    for (symbol in self.session.currentExpression.symbols) {
        CGRect innerFrame = symbol.boundingBox;
        CGRect containingFrame = CGRectMake(innerFrame.origin.x-10, innerFrame.origin.y-10, innerFrame.size.width+20, innerFrame.size.height+20);
        EXSymbolView *newView = [[EXSymbolView alloc] initWithFrame:containingFrame];
        newView.delegate = self;
        [newView setNewSymbol:symbol];
        self.boundingBoxes = [self.boundingBoxes arrayByAddingObject:newView];
    }
    
    // Show our bounding boxes.
    [self showBoundingBoxes];
   
}

/**
 *  Stub for overriding.
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

// (Documented in header file)
- (IBAction)toggleBoundingBoxes:(id)sender {
    if(self.boundingBoxesShowing) {
        [self hideBoundingBoxes];
    } else {
        [self showBoundingBoxes];
    }
}

// (Documented in header file)
- (IBAction)startOver:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

// (Documented in header file)
- (IBAction)processChanges:(id)sender {
    
    // Disable next button.
    self.nextButton.enabled = NO;
    
    NSArray *allSymbols = [[NSArray alloc] init];
    EXSymbolView *symbolView;
    for(symbolView in self.boundingBoxes) {
        allSymbols = [allSymbols arrayByAddingObject:symbolView.symbol];
    }
    
    // Create, configure, and show HUD.
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.labelText = @"Sending changes...";
    
    [self.session updateSymbolsWithArray:allSymbols from:self];
}

#pragma mark - Manipulate Bounding Boxes

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

#pragma mark - Handle Symbol Selection & Editing

// (Documented in header file)
- (void)symbolSelected:(id)sender {
    if( [sender class] == [EXSymbolView class] ) {
        EXSymbolView *view = (EXSymbolView *)sender;
        [self displayEditingDialogWithSymbolView:view];
    } else {
        [NSException raise:@"Non-EXSymbolView sent symbolSelected." format:@"Thrower was actually of class %@.", [sender class]];
    }
}

/**
 *  Stub for displaying the edit view for a given symbolView and its symbol.
 *
 *  @param  symbolView    The view whose symbol we should modify with this dialog.
 */
- (void)displayEditingDialogWithSymbolView:(EXSymbolView *)symbolView {
    // Do something here to display the editing dialog.
    CGRect cropBox = symbolView.symbol.boundingBox;
    CGImageRef ref = CGImageCreateWithImageInRect([self.imageView.image CGImage], cropBox);
    UIImage *croppedImage = [UIImage imageWithCGImage:ref];
    EXSymbolCorrectionViewController *cVC = (EXSymbolCorrectionViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"symbolCorrection"];
    cVC.image = croppedImage;
    cVC.symbol = symbolView.symbol;
        
    if([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
        
        [cVC setModalTransitionStyle:UIModalTransitionStylePartialCurl];
        [self presentModalViewController:cVC animated:YES];
        
    } else {
        if(!self.pop) {
            self.pop = [[UIPopoverController alloc] initWithContentViewController:cVC];
            self.pop.delegate = self;
            cVC.modalInPopover = YES;
            cVC.pop = self.pop;
            [self.pop presentPopoverFromRect:symbolView.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    }
    
}

// Already documented.
- (void)symbolsReceived:(ASIHTTPRequest *)request {
    if(request.responseStatusCode==500 || request.responseStatusCode==404) {
        
        [self symbolsNotReceived:request];
        
    } else {
        
        // Change HUD mode.
        self.hud.mode = MBProgressHUDModeIndeterminate;
        self.hud.labelText = @"Making up some math...";
        
        // Get symbols!
        [self.session getEquationsFrom:self];
        
    }
}

// Already documented.
- (void)symbolsNotReceived:(ASIHTTPRequest *)request {
    // Reenable next button.
    self.nextButton.enabled = YES;
    UIAlertView *aV = [[UIAlertView alloc] initWithTitle:@"Update Failed" message:@"Barista couldn't process your changes." delegate:self cancelButtonTitle:@"Back" otherButtonTitles:@"Try Again", nil];
    [aV show];
}

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
            if([alertView.title isEqualToString:@"Update Failed"]) {
                [self processChanges:self];
            } else {
                //[self showEquation];
            }
        default:
            // Do nothing.
            break;
    }

}

// Already documented.
- (void)receiveEquations:(ASIHTTPRequest *)request {
    if(request.responseStatusCode==500 || request.responseStatusCode==404) {
        
        [self equationsFailed:request];
        
    } else {
        
        // Do stuff.
        // Get Dictionary of the data.
        NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:request.responseData
                                                                     options:NSJSONReadingAllowFragments
                                                                       error:nil];
        // Pull the symbols out of the data.
        NSString *code = [responseData valueForKey:@"tex"];
        
        EXEquation *equation = [[EXEquation alloc] init];
        equation.latexEncoding = code;        
        equation.equationImage = [self.session getEquationImageForIdentifier:@"silly"];
        
        // Change HUD mode.
        self.hud.mode = MBProgressHUDModeIndeterminate;
        self.hud.labelText = @"Math received!";
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        self.nextButton.enabled = YES;
        
        NSArray *newEquations = [NSArray arrayWithObject:equation];
        self.session.currentExpression.equations = newEquations;
        
        [self performSegueWithIdentifier:@"VerificationToMath" sender:self];
        
    }
}

// Already documented.
- (void)equationsFailed:(ASIHTTPRequest *)request {
    
    self.nextButton.enabled = YES;
    UIAlertView *aV = [[UIAlertView alloc] initWithTitle:@"Equation Retrieval Failed" message:@"Barista had some trouble composing equations from your written math." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Try Again", nil];
    [aV show];
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    EXEquationViewController *vC = (EXEquationViewController *)[segue destinationViewController];
    vC.session = self.session;
    
}

@end
