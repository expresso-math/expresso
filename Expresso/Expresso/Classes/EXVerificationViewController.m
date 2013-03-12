//
//  EXVerificationViewController.m
//  Expresso
//
//  Created by Josef Lange on 3/8/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import "EXVerificationViewController.h"

@interface EXVerificationViewController ()

@end

@implementation EXVerificationViewController

@synthesize session = _session;
@synthesize boundingBoxes = _boundingBoxes;
@synthesize imageView = _imageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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
    UIView *view;
    for (view in self.boundingBoxes) {
        [self.view addSubview:view];
    }
    self.boundingBoxesShowing = YES;
}

- (void)hideBoundingBoxes {
    UIView *view;
    for (view in self.boundingBoxes) {
        [view removeFromSuperview];
    }
    self.boundingBoxesShowing = NO;
    
}

@end
