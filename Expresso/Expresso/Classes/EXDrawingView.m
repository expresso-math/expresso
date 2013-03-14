//
//  EXDrawingView.m
//  Expresso
//
//  Created by Josef Lange on 2/21/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import "EXDrawingView.h"
#import <QuartzCore/QuartzCore.h>

@interface EXDrawingView ()

@property (strong, nonatomic) UIBezierPath *path;
@property (strong, nonatomic) UIImage *cachedImage;

@end

@implementation EXDrawingView {
    
    CGPoint pts[5];
    uint ctr;
}

@synthesize drawingViewDelegate = _drawingViewDelegate;
@synthesize path = _path;
@synthesize cachedImage = _cachedImage;

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

- (UIBezierPath *)path {
    if(!_path) { _path = [UIBezierPath bezierPath]; }
    return _path;
}

// No lazy instantiation of cachedImage, because we're depending on it being nil at some point.

/*
 *  Some common setup actions. Setting the primary state of the view, including
 *  its style, touch capability, background color, initializing some member variables.
 */
- (void)drawingSetup {
    
    [self setMultipleTouchEnabled:NO];
    [self setBackgroundColor:[UIColor whiteColor]];
    self.path = [UIBezierPath bezierPath];
    
    [self.path setLineWidth:[self lineWidth]];
    
}

- (float)lineWidth {
    // Here just in case we want to scale stroke size by device. Not sure at this point.
    return [[[NSUserDefaults standardUserDefaults] valueForKey:@"strokeWidth"] floatValue];
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
        [self.path moveToPoint:pts[0]];
        
        // Add the curve to our averaged point 4 (index 3) with the captured
        // points defining its directionality and magnitude.
        [self.path addCurveToPoint:pts[3] controlPoint1:pts[1] controlPoint2:pts[2]];
        
        // Chomp through and reset our counter.
        pts[0] = pts[3];
        pts[1] = pts[4];
        ctr = 1;
        
        // Set the flag to draw.
        [self setNeedsDisplay];
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
    // Get our touchpoint.
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    
    [self.path setLineWidth:[self lineWidth]];
    
    // Making up an arbitrary point area to determine whether or not we
    // drew something.
    CGRect pointSize = CGRectMake(p.x-3, p.y-3, 6, 6);
    
    // If the bounds of our total drawing is smaller than that arbitrary
    // bounding box, we most likely meant to draw a point.
    if(CGRectContainsRect(pointSize, [self.path bounds])) {
        // Add an arc (a 360-degree one, so a circle) to the path at the
        // touchpoint.
        [self.path addArcWithCenter:p
                        radius:[[[NSUserDefaults standardUserDefaults] valueForKey:@"strokeWidth"] floatValue] * 0.3
                    startAngle:0.0
                      endAngle:(3.141592*2.0)
                     clockwise:YES];
        [self.path setLineWidth:[self lineWidth] * 0.6];
    }
    
    [self.drawingViewDelegate drawingDidEnd:self.path];
    
    // Fully reset counter.
    ctr = 0;
    
    // We finished scribbling. Handle the previously-drawn path caching.
    [self setNeedsDisplay];
    [self drawBitmap];
    
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
 *  Given the array of paths, erase the cached image and draw over
 *  a blank image context, capturing them into a new cached image.
 *
 */
-(void)redrawFromPaths:(NSArray *)paths {
    
    [self.path removeAllPoints];
    self.cachedImage = nil;
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0.0);
    
    
    UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:self.bounds];
    [[UIColor whiteColor] setFill];
    [rectPath fill];
    
    [self.cachedImage drawAtPoint:CGPointZero];
    
    for(UIBezierPath *p in paths) {
        [p stroke];
    }
    
    self.cachedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();

    
}

/*
 *  Override of UIView's main drawRect method. Set line width given our
 *  object's current line width, draw the cached image, stroke our path,
 *  and fill it if it's a dot only.
 *
 *  @param  (CGRect)rect    The rectangle in which to draw.
 */
- (void)drawRect:(CGRect)rect {
    
    [self.cachedImage drawInRect:rect];
    [self.path setLineWidth:[self lineWidth]];
    [self.path stroke];
    
}


/*
 *  Draw cached image with most recent path over the top, then
 *  add that path to the cached image.
 */
- (void)drawBitmap {

    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0.0);

    if(!self.cachedImage) {
        UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:self.bounds];
        [[UIColor whiteColor] setFill];
        [rectPath fill];
    }
    
    [self.cachedImage drawAtPoint:CGPointZero];

    [self.path stroke];

    self.cachedImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    
    // Clear path.
    [self.path removeAllPoints];

}

@end
