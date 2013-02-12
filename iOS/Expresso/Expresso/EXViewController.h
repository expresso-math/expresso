//
//  EXViewController.h
//  Expresso
//
//  Created by Josef Lange on 2/6/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EXDrawingInterpretationView.h"

@interface EXViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet EXDrawingInterpretationView *drawingView;
@property (weak, nonatomic) IBOutlet UISlider *strokeWidthSlider;
@property (weak, nonatomic) IBOutlet UILabel *strokeWidthLabel;

-(IBAction)showPopoverFromButton:(id)sender;

@end
