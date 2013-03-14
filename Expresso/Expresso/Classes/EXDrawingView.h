//
//  EXDrawingView.h
//  Expresso
//
//  Created by Josef Lange on 2/21/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 * Protocol so EXDrawingView can tell someone that drawing ended.
 */
@protocol EXDrawingViewDelegate

/* 
 *  Event fired off to delegate with information on the most-recently
 *  completed stroke.
 *
 *  @param path The path just drawn.
 */
- (void)drawingDidEnd:(UIBezierPath *)path;

@end


/**
 *  This class is a subclass of UIView that allows drawing. It has a delegate
 *  which responds to an event fired off at the end of every draw moment.
 */

@interface EXDrawingView : UIView {
     id<EXDrawingViewDelegate> drawingViewDelegate;
}

/** The drawing view delegate. Receives drawingDidEnd: from this object. */
@property (nonatomic, assign) id<EXDrawingViewDelegate> drawingViewDelegate;


/** 
 *  Redraw the view from the given paths.
 *
 *  These paths, hopefully, have come from an EXDrawing object, and more hopefully
 *  one that was used recently so as to avoid any change in frame.
 *
 *  @param paths an array of UIBezerPath objects
 */
-(void)redrawFromPaths:(NSArray *)paths;

@end
