//
//  EXRecognitionVerificationViewController.h
//  Expresso
//
//  Created by Josef Lange on 2/27/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EXProgressHUDView.h"
#import "EXRecognizedExpression.h"
#import "EXRecognizedCharacterView.h"

@interface EXRecognitionVerificationViewController : UIViewController

@property (strong, nonatomic) EXRecognizedExpression *expression;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet EXProgressHUDView  *hud;
//@property (strong, nonatomic) 

- (IBAction)toggleBoundingBoxes:(id)sender;

@end
