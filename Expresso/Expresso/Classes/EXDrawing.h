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

/** An array of UIBezierPath objects, lazily instantiated. */
@property (strong, nonatomic, readonly) NSArray *drawnPaths;

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
 * Clear out all the paths in the drawnPaths property.
 */
- (void)clearPaths;

/**
 *  Generating getter for property renderedImage.
 *
 *  Contacts the App Delegate to get a hold of the root navigation controller, which then
 *  gives us the view controller it's displaying, from which we can gather the size of the view
 *  in which the user was drawing, since that changes between form factor and Retina-ability. From
 *  there, it creates an image context to grab the image. Works a lot like the caching in
 *  EXDrawingView.
 *
 *  @return The image the paths represent, rendered.
 */
- (UIImage *)renderedImage;

@end
