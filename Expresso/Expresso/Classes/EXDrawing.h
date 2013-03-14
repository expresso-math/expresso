//
//  EXDrawing.h
//  Expresso
//
//  (MODEL)
//
//  Created by Josef Lange on 2/21/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  This class encapsulates the individual stroke paths of a drawing. These paths can be recomposed
 *  into a complete drawing and/or manipulated one-by-one.
 */

@interface EXDrawing : NSObject

/** An array of UIBezierPath objects. */
@property (strong, nonatomic, readonly) NSArray *drawnPaths;

/** The image rendered from the paths. Not actually really stored; the getter generates it. */
@property (strong, nonatomic, readonly, getter = renderedImage) UIImage *renderedImage;


/** 
 * Add a UIBezierPath to self.drawnPaths.
 *
 * @param newPath The path to add.
 */
- (void)addPath:(UIBezierPath *)newPath;

/**
 * Pop off the most recent-added path.
 * 
 * Useful for undoing.
 * 
 * @return The most recently-added path.
 */
- (UIBezierPath *)removeMostRecentPath;

/**
 * Remove a specific UIBezierPath object from self.drawnPaths.
 *
 * This relies on being able to identify the path by pointer...
 *
 * @param path The path to remove.
 */
- (void)removePath:(UIBezierPath *)path;

/**
 * Clear out all the paths.
 */
- (void)clearPaths;

@end
