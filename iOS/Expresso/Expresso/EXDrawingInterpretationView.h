//
//  EXDrawingInterpretationView.h
//  Expresso
//
//  Created by Josef Lange on 2/6/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EXDrawingInterpretationView : UIView

@property (strong, nonatomic) NSNumber *strokeWidth;

- (void)eraseView;
- (NSData *)getImageData;

@end