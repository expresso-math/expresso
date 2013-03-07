//
//  EXProgressHUDView.m
//  Expresso
//
//  Created by Josef Lange on 3/7/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import "EXProgressHUDView.h"
#import <QuartzCore/QuartzCore.h>

@implementation EXProgressHUDView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)showBar {
    [self.cog stopAnimating];
    [self.cog setHidden:YES];
    [self.bar setHidden:NO];
}

-(void)showCog {
    [self.bar setHidden:YES];
    [self.cog setHidden: NO];
    [self.cog startAnimating];
}

@end
