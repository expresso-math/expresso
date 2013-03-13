//
//  EXVerificationViewController.h
//  Expresso
//
//  Created by Josef Lange on 3/8/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EXSession.h"

@interface EXVerificationViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton;
@property (strong, nonatomic) EXSession *session;
@property (strong, nonatomic) NSArray *boundingBoxes;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (readwrite, nonatomic) BOOL boundingBoxesShowing;

- (IBAction)toggleBoundingBoxes:(id)sender;
- (IBAction)startOver:(id)sender;

@end
