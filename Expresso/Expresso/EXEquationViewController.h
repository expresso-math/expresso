//
//  EXEquationViewController.h
//  Expresso
//
//  Created by Josef Lange on 5/7/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EXSession.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface EXEquationViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) EXSession *session;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

-(IBAction)startOver:(id)sender;
-(IBAction)copyCode:(id)sender;
-(IBAction)emailCode:(id)sender;

@end
