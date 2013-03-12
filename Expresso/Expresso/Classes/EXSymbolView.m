//
//  EXRecognizedCharacterView.m
//  Expresso
//
//  Created by Josef Lange on 3/7/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import "EXSymbolView.h"
#import <QuartzCore/QuartzCore.h>

@implementation EXSymbolView

@synthesize characterLabel = _characterLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.layer.borderWidth = 2.0f;
        
        self.layer.cornerRadius = 5.0f;
        self.layer.masksToBounds = YES;
        
        self.characterLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 50)];
        self.characterLabel.font = [UIFont fontWithName:@"Arial" size:24.0f];
        self.characterLabel.text = @"A";
        self.characterLabel.textAlignment = NSTextAlignmentCenter;
        self.characterLabel.backgroundColor = [UIColor darkGrayColor];
        self.characterLabel.textColor = [UIColor lightTextColor];
        
        [self addSubview:self.characterLabel];
        
    }
    return self;
}

@end
