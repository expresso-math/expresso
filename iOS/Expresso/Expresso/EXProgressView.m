//
//  EXProgressView.m
//  Expresso
//
//  Created by Josef Lange on 2/14/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import "EXProgressView.h"


@interface EXProgressView ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityGlyph;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end

@implementation EXProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

/*
 *  Turn the ActivityIndicatorView.
 */
- (void)turnGears {
    [self.activityGlyph startAnimating];
}

/*
 *  Stop it and update to show "Done!" for the last second.
 */
- (void)stopGears {
    [self.activityGlyph stopAnimating];
    [self.textLabel setText:@"Done!"];
}

@end
