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

/**
 *  The first view of a user interact. Tells the user how to start.
 *  Gets session. Voila.
 */

@interface EXWelcomeViewController : UIViewController <UIAlertViewDelegate, UIPopoverControllerDelegate>

/** The current EXSession. */
@property (strong, nonatomic) EXSession *session;
/** The button on the UINavigationBar that will send us to the next stage. */
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton;
/** Popover controller, if we use it... */
@property (strong, nonatomic) UIPopoverController *pop;


/**
 *  Conect to a session with Barista.
 *
 *  @param sender The sending object.
 */
-(IBAction)connectToSession:(id)sender;

/**
 *  Start the segue to training mode.
 *
 *  @param  sender  The sending object.
 */
-(IBAction)segueToTraining:(id)sender;

/**
 *  Show us our server settings GUI so we can select localhost, Heroku, or manual.
 *
 *  @param  sender  The sending object.
 */
-(IBAction)showServerSettings:(id)sender;

/**
 * The ASIHTTPRequest from EXSession completed, let's do something 
 * with its data (like fill in EXSession and move on!)
 *
 * @param request The completed request.
 */
-(void)receiveSession:(ASIHTTPRequest *)request;

/**
 * The ASIHTTPRequest from EXSession failed, let's do something
 * about it!
 *
 * @param request The failed request.
 */
-(void)sessionFailed:(ASIHTTPRequest *)request;
@end
