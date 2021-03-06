//
//  EXLandscapeNavigationController.m
//  Expresso
//
//  Created by Josef Lange on 3/8/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import "EXLandscapeNavigationController.h"

@interface EXLandscapeNavigationController ()

@end

@implementation EXLandscapeNavigationController

#pragma mark - View Lifecycle

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
    }
    return self;
}

/**
 *  Override of viewDidLoad for us to modify the NavigationBar and ToolBar tint.
 */
- (void)viewDidLoad {
    [super viewDidLoad];

    UIColor *color = [UIColor colorWithRed:68/255.0f green:30/255.0f blue:0/255.0f alpha:1.0f];
    self.navigationBar.tintColor = color;
    self.toolbar.tintColor = color;
    
}

#pragma mark - Screen Orientation


@end
