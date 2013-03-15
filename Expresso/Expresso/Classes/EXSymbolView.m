//
//  EXRecognizedCharacterView.m
//  Expresso
//
//  Created by Josef Lange on 3/7/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import "EXSymbolView.h"
#import <QuartzCore/QuartzCore.h>

@interface EXSymbolView ()

@property (strong, nonatomic) UIView *labelBackground; // Background of the label.

@end

@implementation EXSymbolView


@synthesize labelBackground = _labelBackground;
@synthesize symbolLabel = _symbolLabel;


#pragma mark - UIView
/**
 *  Override to build our cool little bounding box.
 *
 *  @param  frame   The frame in which to construct our view/control.
 */
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        // Make a nice brownish color. This is subject to change; I'm not sure if I like it. I might just
        // go for a transparent black.
        UIColor *color = [UIColor colorWithRed:182/255.0f green:115/255.0f blue:67/255.0f alpha:1.0f];
        
        // Set up the bounding box. Background, border, and corner radius (including masking).
        self.backgroundColor = [UIColor clearColor];
        self.layer.borderColor = color.CGColor;
        self.layer.borderWidth = 3.0f;        
        self.layer.cornerRadius = 10.0f;
        self.layer.masksToBounds = YES;
        
        // Create and set up the background behind our label. We could just use the label's background
        // itself, since UILabel is a subclass of UIView, but I wanted to offset the label's text
        // somehow, and putting it in another view worked best.
        self.labelBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 40)];
        self.labelBackground.backgroundColor = color;
        self.labelBackground.layer.cornerRadius = 5.0f;
        self.labelBackground.layer.masksToBounds = YES;
        
        // Create and set up the label. Pretty trivial at this point.
        self.symbolLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, 0, 25, 40)];
        self.symbolLabel.backgroundColor = [UIColor clearColor];
        self.symbolLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
        self.symbolLabel.text = @"A";
        self.symbolLabel.textAlignment = NSTextAlignmentCenter;
        self.symbolLabel.textColor = [UIColor whiteColor];
        
        // Disable interaction on the label, so this view gets touch events.
        self.symbolLabel.userInteractionEnabled = NO;
        self.labelBackground.userInteractionEnabled = NO;
        
        // Add the views as subviews of this view.
        [self addSubview:self.labelBackground];
        [self addSubview:self.symbolLabel];
        
        // Set up target action with delegate for responding to touches.
        [self addTarget:self.delegate action:@selector(symbolSelected:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

@end
