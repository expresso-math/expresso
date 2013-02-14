//
//  EXDrawingInterpretationView.h
//  Expresso
//
//  Created by Josef Lange on 2/6/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EXDrawingInterpretationView : UIView

// The width at which to draw any touch strokes.
@property (strong, nonatomic) NSNumber *strokeWidth;

/*
 *  Erase the contents of this view. Works by pasting
 *  a big fat white rectangle over the whole view.
 */
- (void)eraseView;

/*
 *  Get the data of the represented image as NSData
 *  (formatted as PNG).
 *
 *  @return     NSData*     The image data.
 */
- (NSData *)getImageData;

@end