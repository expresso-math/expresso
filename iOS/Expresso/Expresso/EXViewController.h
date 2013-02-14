//
//  EXViewController.h
//  Expresso
//
//  Created by Josef Lange on 2/6/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <DropboxSDK/DropboxSDK.h>
#import "EXDrawingInterpretationView.h"
#import "EXProgressView.h"
#import "EXSettingsPopoverContentViewController.h"

@interface EXViewController : UIViewController <MFMailComposeViewControllerDelegate, DBRestClientDelegate, UIPopoverControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet EXDrawingInterpretationView *drawingView;
@property (weak, nonatomic) IBOutlet EXProgressView *progressView;
@property (strong, nonatomic) DBRestClient *restClient; // The DropBox REST client.
@property (strong, nonatomic) UIPopoverController *settingsPopoverController;

@end
