//
//  EXDrawing.h
//  Expresso
//
//  (MODEL)
//
//  This class encapsulates the individual stroke paths of a drawing. These paths can be recomposed
//  into a complete drawing and/or manipulated one-by-one.
//
//  Created by Josef Lange on 2/21/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EXDrawing : NSObject

@property (strong, nonatomic, readonly) NSArray *drawnPaths; // Data Structure for all our paths.


//  Add the given path to the drawing.
- (void)addPath:(UIBezierPath *)newPath;

//  Remove the most recent path. (Useful for undoing).
- (UIBezierPath *)removeMostRecentPath;

//  Remove a given path.
- (void)removePath:(UIBezierPath *)path;

//  Clear all paths.
- (void)clearPaths;

// Get the rendered image.
- (UIImage *)renderedImage;

@end
