//
//  EXDrawingView.h
//  Expresso
//
//  Created by Josef Lange on 2/21/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import <UIKit/UIKit.h>

// Protocol so our View can ask (very nicely) for the model's paths through the controller.
@protocol EXDrawingViewDelegate

// Event fired off to delegate with information on the most-recently completed stroke.
- (void)drawingDidEnd:(UIBezierPath *)path;

// Protocol method to get all drawn paths from the View Controller.
- (NSArray *)allDrawnPaths;

@end

@interface EXDrawingView : UIView {
     id<EXDrawingViewDelegate> drawingViewDelegate;
}

// Set up an outlet for the EXViewController to become a delegate to the drawingView.
// This allows us to fire off the events in the above protocol.
@property (nonatomic, assign) IBOutlet id<EXDrawingViewDelegate> drawingViewDelegate;

// Erase the view -- set path to nil, etc.
-(void)eraseView;

@end
