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
    
    // Stop and hide activity spinner.
    [self.activityGlyph stopAnimating];
    [self.activityGlyph setHidden:YES];

    // Load our pretty checkmark into a UIImage, then put the
    // UIImage in a UIImageView, and make that a subview ourself.
    NSString *path = [[NSBundle mainBundle] pathForResource: @"checkmark" ofType: @"png"];
    NSLog(@"path: %@", path);
    CGRect drawingFrame = self.activityGlyph.frame;
    UIImage *checkMark = [UIImage imageWithContentsOfFile:path];
    UIImageView *checkMarkView = [[UIImageView alloc] initWithFrame:drawingFrame];
    [checkMarkView setImage:checkMark];
    [self addSubview:checkMarkView];
    
    // Change label.
    [self.textLabel setText:@"Done!"];
}

@end
