//
//  EXDrawingInterpretationView.m
//  Expresso
//
//  Created by Josef Lange on 2/6/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import "EXDrawingInterpretationView.h"
#import <QuartzCore/QuartzCore.h>


@implementation EXDrawingInterpretationView {
    UIBezierPath *path; // The current path being drawn out.
    UIImage *incrementalImage;  // The image of all prior strokes, for caching purposes.
    CGPoint pts[5]; // Keeping track of most recently-touched points to approximate curve.
    uint ctr; // A counter for how many previously-touched points we're holding onto.
    BOOL drewDot;   // Flag to let us know if it was a one-point (or very small) touch, indicating
                    // a dot drawn.
}

/*
 *  Overwritten getter for strokeWidth @property. Lazily instantiates if
 *  it doesn't already exist.
 *
 *  @return NSNumber*   The value of member pointer _strokeWidth's object.
 */
- (NSNumber *)strokeWidth {
    if(!_strokeWidth) _strokeWidth = [NSNumber numberWithFloat:3.0];
    return _strokeWidth;
}

/*
 *  Overwritten initializer, calls drawingSetup after initting the super.
 *  
 *  @return id  A pointer to the new EXDrawingInterpretationView object.
 */
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self drawingSetup];
    }
    return self;
}

/*
 *  Overwritten initializer, calls drawingSetup after initting the super.
 *
 *  @return id  A pointer to the new EXDrawingInterpretationView object.
 */
- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self drawingSetup];
    }
    return self;
}

/*
 *  Some common setup actions. Setting the primary state of the view, including
 *  its style, touch capability, background color, initializing some member variables.
 */
- (void)drawingSetup {
    [self setMultipleTouchEnabled:NO];
    [self setBackgroundColor:[UIColor whiteColor]];
    path = [UIBezierPath bezierPath];
    [path setLineWidth:[self.strokeWidth floatValue]];
    [[self layer] setCornerRadius:5.0];
    [[self layer] setMasksToBounds:YES];
    drewDot = NO;
}

/*
 *  Override of UIView's main drawRect method. Set line width given our
 *  object's current line width, draw the cached image, stroke our path, 
 *  and fill it if it's a dot only.
 *
 *  @param  (CGRect)rect    The rectangle in which to draw.
 */
- (void)drawRect:(CGRect)rect
{
    // Override so we can set the line width given the current value of our
    // member variable, and then draw our incremental image (created to offload
    // stroke processing to cached images of past draws). Then draw the stroke.
    // obviously.
    [path setLineWidth:[self.strokeWidth floatValue]];
    [incrementalImage drawInRect:rect];
    [path stroke];
    if(drewDot) {
        [[UIColor blackColor] setFill];
        [path fill];
        drewDot = NO;
    }
}

/*
 *  Touch-responding method. Fired off when the first touch of a given
 *  stroke happens. Set counter to zero, get the first touch (and location),
 *  Add that position to our pts array.
 *
 *  @param  (NSSet *)touches    The set of touches returned by this event. 
 *                              (One since multi-touch is disabled.
 *
 *  @param (UIEvent *)event     The event attached to these touches. Not so
 *                              important to us here.
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    ctr = 0;
    UITouch *touch = [touches anyObject]; // Get the touch. 
    pts[0] = [touch locationInView:self]; // Get the location of said touch.
}

/*
 *  Responds to the movement of a touch. Adds the touch point to the array,
 *  and if the array is big enough, approximates a curve for those points.
 *
 *  @param  (NSSet *)touches    The set of touches returned by this event.
 *                              (One since multi-touch is disabled.
 *
 *  @param (UIEvent *)event     The event attached to these touches. Not so
 *                              important to us here.
 */
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject]; // Get the one touch.
    CGPoint p = [touch locationInView:self]; // Get the point it's at now.
    ctr++; // Increment poll counter.
    pts[ctr] = p; // Set the most recent point in the approximation array.
    if (ctr == 4)
    {
        // If we've seen five points in this touch, it's time to run an
        // approximation for the curve they represent.
        
        // First, think about the five points representing two curve
        // approximations, the fourth point representing a common point:
        // the end of the first curve and the beginning of the yet-to-be
        // completed second.
        
        // Since the direction and magnitude of the bezier going toward that
        // point can be quite different from that of the one "departing" from
        // that point, it's sound to approximate a better suggested midpoint
        // which allows the curves to line up -- it's actually a Cartesian
        // average the third and fifth points.
        
        // Method derived from: goo.gl/7zWJ8
        pts[3] = CGPointMake((pts[2].x+pts[4].x)/2.0, (pts[2].y+pts[4].y)/2.0);
        
        // Let's move the path to the first point in this curve approximation.
        [path moveToPoint:pts[0]];
        
        // Add the curve to our averaged point 4 (index 3) with the captured
        // points defining its directionality and magnitude.
        [path addCurveToPoint:pts[3] controlPoint1:pts[1] controlPoint2:pts[2]];
        
        // Set the flag to draw.
        [self setNeedsDisplay];
        
        // Chomp through and reset our counter.
        pts[0] = pts[3];
        pts[1] = pts[4];
        ctr = 1;
    }
}

/*
 *  Responds to the end of a touch. Detects whether or not we were a "small enough"
 *  touch to be a "point". If so, set the point drawing flag to YES. Also,
 *  clear path and reset counter for curve approximation.
 *
 *  @param  (NSSet *)touches    The set of touches returned by this event.
 *                              (One since multi-touch is disabled.
 *
 *  @param (UIEvent *)event     The event attached to these touches. Not so
 *
 */
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    // Check if our bounding box is very small. If so, draw a pretty point.
    
    // Get our touchpoint.
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    
    // Making up an arbitrary point area to determine whether or not we
    // drew something.
    CGRect pointSize = CGRectMake(p.x-3, p.y-3, 6, 6);
    
    // If the bounds of our total drawing is smaller than that arbitrary
    // bounding box, we most likely meant to draw a point.
    if(CGRectContainsRect(pointSize, [path bounds])) {
        // Add an arc (a 360-degree one, so a circle) to the path at the
        // touchpoint.
        [path addArcWithCenter:p
                        radius:[self.strokeWidth floatValue] * 0.4
                    startAngle:0.0
                      endAngle:(3.141592*2.0)
                     clockwise:YES];
        // Let the class know we drew a dot.
        drewDot = YES;
      }
    
    // We finished scribbling. Handle the previously-drawn path caching.
    [self setNeedsDisplay];
    [self drawBitmap];

    
    // Clear path.
    [path removeAllPoints];
    
    // Fully reset counter.
    ctr = 0;
}

/*
 *  Responds to the cancellation of a touch. Essentially forwards to touchesEnded.
 *
 *  @param  (NSSet *)touches    The set of touches returned by this event.
 *                              (One since multi-touch is disabled.
 *
 *  @param (UIEvent *)event     The event attached to these touches. Not so
 *
 */
 -(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}

/*
 *  Draw previously-cached state, draw new path, cache whole image.
 */
- (void)drawBitmap
{
    // Set up UIGraphicsImageContext.
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0.0);
    
    if (!incrementalImage) // First time; paint background white.
    {
        UIBezierPath *rectpath = [UIBezierPath bezierPathWithRect:self.bounds];
        [[UIColor whiteColor] setFill];
        [rectpath fill];
    }
    
    // Draw previous state of the capture.
    [incrementalImage drawAtPoint:CGPointZero];
    
    // Set stroke color.
    [[UIColor blackColor] setStroke];
    
    // Stroke current path.
    [path setLineWidth:[self.strokeWidth floatValue]];
    [path stroke];
    
    // If we detected we touched a dot, fill the arc we drew.
    if(drewDot) {
        [[UIColor blackColor] setFill];
        [path fill];
        drewDot = NO;
    }
    
    // Cache newly-updated capture.
    incrementalImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // Close down the UIGraphicsImageContext.
    UIGraphicsEndImageContext();
}

/*
 *  Erase the view. Just overwrites the rectangle with a white rectangle.
 *  Kind of a hack.
 */
- (void)eraseView {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0.0);
    UIBezierPath *rectpath = [UIBezierPath bezierPathWithRect:self.bounds];
    [[UIColor whiteColor] setFill];
    [rectpath fill];
    incrementalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self drawBitmap];
    [self setNeedsDisplay];
}

/*
 *  Return the PNG representation of the cached image.
 *
 *  @return NSData* The PNG data for the cached image.
 */
- (NSData *)getImageData {
    return UIImagePNGRepresentation(incrementalImage);
}
@end