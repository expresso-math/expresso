//
//  EXWelcomeViewController.h
//  Expresso
//
//  Created by Josef Lange on 3/8/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EXDrawingViewController.h"
#import "EXSession.h"
#import "MBProgressHUD.h"

@interface EXWelcomeViewController : UIViewController <UIAlertViewDelegate>

@property (strong, nonatomic) EXSession *session;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton;

-(IBAction)connectToSession:(id)sender;
-(void)receiveSession:(ASIHTTPRequest *)request;
-(void)sessionFailed:(ASIHTTPRequest *)request;
@end
