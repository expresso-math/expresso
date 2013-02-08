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
    UIBezierPath *path;
    UIImage *incrementalImage;
    CGPoint pts[5]; // we now need to keep track of the four points of a Bezier
                    // segment and the first control point of the next segment.
    uint ctr;
}

- (NSNumber *)strokeWidth {
    if(!_strokeWidth) _strokeWidth = [NSNumber numberWithFloat:1.0];
    return _strokeWidth;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    // Need to override so we can set a few things. Namely, disable multitouch,
    // background color, and so we can create and configure our path before
    // drawing it.
    if (self = [super initWithCoder:aDecoder])
    {
        [self drawingSetup];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    // Need to override so we can set a few things. Namely, disable multitouch,
    // background color, and so we can create and configure our path before
    // drawing it.
    self = [super initWithFrame:frame];
    if (self) {
        [self drawingSetup];
    }
    return self;
}

// Essentially a macro for the init overrides.
- (void)drawingSetup {
    [self setMultipleTouchEnabled:NO];
    [self setBackgroundColor:[UIColor whiteColor]];
    path = [UIBezierPath bezierPath];
    [path setLineWidth:[self.strokeWidth floatValue]];
    [[self layer] setCornerRadius:5.0];
    [[self layer] setMasksToBounds:YES];
}

- (void)drawRect:(CGRect)rect
{
    // Override so we can set the line width given the current value of our
    // member variable, and then draw our incremental image (created to offload
    // stroke processing to cached images of past draws). Then draw the stroke.
    // obviously.
    [path setLineWidth:[self.strokeWidth floatValue]];
    [incrementalImage drawInRect:rect];
    [path stroke];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Fires off when first touch is made with the view. The counter variable
    // is manually set to zero to start, and the first point in our bezier
    // approximation array is set.
    ctr = 0;
    UITouch *touch = [touches anyObject]; // Get the touch. The set of touches
                                          // should hopefully only have one
                                          // touch, as we set this view to not
                                          // accept multi-touch.
    pts[0] = [touch locationInView:self]; // Get the location of said touch.
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // A current touch has moved.
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
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{    
    // We finished scribbling. Handle the previously-drawn path caching.
    [self drawBitmap];
    [self setNeedsDisplay];
    
    // Clear path.
    [path removeAllPoints];
    
    // Fully reset counter.
    ctr = 0;
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    // If touches get cancelled somehow, just forward to touchesEnded.
    [self touchesEnded:touches withEvent:event];
}
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
    [path stroke];
    
    // Cache newly-updated capture.
    incrementalImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // Close down the UIGraphicsImageContext.
    UIGraphicsEndImageContext();
}

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
@end