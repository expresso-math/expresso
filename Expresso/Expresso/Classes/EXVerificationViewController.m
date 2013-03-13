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

- (NSArray *)boundingBoxes {
    if(!_boundingBoxes) {
        _boundingBoxes = [[NSArray alloc] init];
    }
    return _boundingBoxes;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.boundingBoxesShowing = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {

    self.imageView.image = self.session.currentExpression.image;
    [self.imageView sizeToFit];

    EXSymbol *symbol;
	// Do any additional setup after loading the view.
    for (symbol in self.session.currentExpression.symbols) {
        EXSymbolView *newView = [[EXSymbolView alloc] initWithFrame:symbol.boundingBox];
        self.boundingBoxes = [self.boundingBoxes arrayByAddingObject:newView];
    }
    
    [self showBoundingBoxes];
    
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toggleBoundingBoxes:(id)sender {
    if(self.boundingBoxesShowing) {
        [self hideBoundingBoxes];
    } else {
        [self showBoundingBoxes];
    }
}

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

@end
