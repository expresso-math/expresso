//
//  EXSettingsPopoverContentViewController.h
//  Expresso
//
//  Created by Josef Lange on 2/14/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EXSettingsPopoverContentViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISlider *strokeWidthSlider;
@property (weak, nonatomic) IBOutlet UILabel *strokeWidthLabel;

- (void)updateStrokeWidthUI:(NSNumber *)newStrokeWidth;

@end
