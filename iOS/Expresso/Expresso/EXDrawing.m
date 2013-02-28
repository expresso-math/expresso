//
//  EXDrawing.m
//  Expresso
//
//  Created by Josef Lange on 2/21/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import "EXDrawing.h"

@interface EXDrawing ()

@property (strong, nonatomic) NSArray *drawnPaths; // Data structure for all our paths.

@end

@implementation EXDrawing

@synthesize drawnPaths = _drawnPaths;

//  Override for init if we want.
- (id)init {
    self = [super init];
    if(self) {
        
    }
    return self;
}

//  Lazy instantiation for drawnPaths.
- (NSArray *)drawnPaths {
    if(!_drawnPaths) { _drawnPaths = [[NSArray alloc] init]; }
    return _drawnPaths;
}

//  Add a path to our drawn paths NSArray.
- (void)addPath:(UIBezierPath *)newPath {
    NSArray *newArray = [self.drawnPaths arrayByAddingObject:newPath];
    self.drawnPaths = newArray;
}

//  Utility method for undo/redo usage.
- (UIBezierPath *)removeMostRecentPath {
    UIBezierPath *removedPath = nil;
    if(self.drawnPaths.count > 0) {
        NSRange range = NSMakeRange(0, self.drawnPaths.count-1);
        removedPath = self.drawnPaths.lastObject;
        self.drawnPaths = [self.drawnPaths subarrayWithRange:range];
    }
    return removedPath;
}

- (void)removePath:(UIBezierPath *)path {
    if([self.drawnPaths containsObject:path]) {
        NSMutableArray *tempArray = [self.drawnPaths mutableCopy];
        [tempArray removeObject:path];
        self.drawnPaths = [NSArray arrayWithArray:tempArray];
    }
}

//  Clear all paths.
- (void)clearPaths {
    self.drawnPaths = nil;
}

- (UIImage *)renderedImage {
    
    UIImage *returnImage = nil;
    
    if(self.drawnPaths.count>0) {
        
        CGRect imageRect = CGRectMake(0, 0, 1024, 660);
        UIGraphicsBeginImageContextWithOptions(imageRect.size, YES, 0.0);
        
        UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:imageRect];
        [[UIColor whiteColor] setFill];
        [rectPath fill];
        
        for(UIBezierPath *p in self.drawnPaths) {
            [p stroke];
        }
        
        returnImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
    }
    
    return returnImage;
}

@end
