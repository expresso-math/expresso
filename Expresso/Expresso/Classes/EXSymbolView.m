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

@property (strong, nonatomic) UIView *labelBackground;
@property (strong, nonatomic) UILabel *characterLabel;

@end

@implementation EXSymbolView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
        UIColor *color = [UIColor grayColor];
        
        self.backgroundColor = [UIColor clearColor];
        self.layer.borderColor = color.CGColor;
        self.layer.borderWidth = 5.0f;
        
        self.layer.cornerRadius = 10.0f;
        self.layer.masksToBounds = YES;
        
        self.labelBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 60)];
        self.labelBackground.backgroundColor = color;
        self.labelBackground.layer.cornerRadius = 5.0f;
        self.labelBackground.layer.masksToBounds = YES;
        
        self.characterLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 35, 60)];
        self.characterLabel.backgroundColor = [UIColor clearColor];
        self.characterLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:24.0f];
        self.characterLabel.text = @"A";
        self.characterLabel.textAlignment = NSTextAlignmentCenter;
        self.characterLabel.textColor = [UIColor blackColor];
        
        [self addSubview:self.labelBackground];
        [self addSubview:self.characterLabel];
    }
    return self;
}

@end
