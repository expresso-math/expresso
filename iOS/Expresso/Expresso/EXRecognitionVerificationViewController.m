//
//  EXRecognitionVerificationViewController.m
//  Expresso
//
//  Created by Josef Lange on 2/27/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import "EXRecognitionVerificationViewController.h"

@implementation EXRecognitionVerificationViewController

@synthesize image = _image;
@synthesize imageView = _imageView;
/*
 *  Help force landscape.
 */
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortrait);
}

- (void)viewDidLoad {
    
    self.imageView.image = self.image;

}

@end
