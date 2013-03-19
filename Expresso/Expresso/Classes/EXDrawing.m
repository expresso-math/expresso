//
//  EXDrawing.m
//  Expresso
//
//  Created by Josef Lange on 2/21/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import "EXDrawing.h"
#import "EXAppDelegate.h"
#import "EXLandscapeNavigationController.h"

@interface EXDrawing ()

@property (strong, nonatomic) NSArray *drawnPaths; // Data structure for all our paths.

@end

@implementation EXDrawing

@synthesize drawnPaths = _drawnPaths;

#pragma mark - Property Instantiation

- (NSArray *)drawnPaths {
    if(!_drawnPaths) { _drawnPaths = [[NSArray alloc] init]; }
    return _drawnPaths;
}

#pragma mark - Advanced State Manipulation

// (Documented in header file)
- (void)addPath:(UIBezierPath *)newPath {
    NSArray *newArray = [self.drawnPaths arrayByAddingObject:newPath];
    self.drawnPaths = newArray;
}

// (Documented in header file)
- (void)removePath:(UIBezierPath *)path {
    if([self.drawnPaths containsObject:path]) {
        NSMutableArray *tempArray = [self.drawnPaths mutableCopy];
        [tempArray removeObject:path];
        self.drawnPaths = [NSArray arrayWithArray:tempArray];
    }
}

- (UIImage *)renderedImage {
    
    // Make pointer.
    UIImage *returnImage = nil;
    
    // Get app delegate.
    EXAppDelegate *appDelegate = (EXAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // Get the NavigationController as well as the view in the currently-showing viewController.
    EXLandscapeNavigationController *nc = (EXLandscapeNavigationController *)appDelegate.window.rootViewController;
    UIView *view = nc.visibleViewController.view;
    
    // Create image context given those bounds.
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0.0);
    
    // Make a white background for this image, since we're sending this to the server and want
    // the most contrast possible.
    //
    // NOTE: Might want to change to a clear background, if possible.
    //
    UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:view.bounds];
    [[UIColor whiteColor] setFill];
    [rectPath fill];
    
    // Stroke all the paths. If there are no paths, oh well.
    for(UIBezierPath *p in self.drawnPaths) {
        [p stroke];
    }
    
    // Get the image from the context.
    returnImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // Close the context.
    UIGraphicsEndImageContext();
    
    // Return!
    return returnImage;
}


#pragma mark - Undo/Redo Utility Methods

// (Documented in header file)
- (UIBezierPath *)removeMostRecentPath {
    UIBezierPath *removedPath = self.drawnPaths.lastObject;
    [self removePath:removedPath];
    return removedPath;
}

#pragma mark - Utility Methods

// (Documented in header file)
- (void)clearPaths {
    self.drawnPaths = nil;
}

@end
