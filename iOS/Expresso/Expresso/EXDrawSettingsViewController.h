//
//  EXDrawSettingsPopoverController.h
//  Expresso
//
//  (CONTROLLER)
//
//  This controller the settings view for this application. This view is presented, on iPad,
//  via a UIPopover. So far, it manages stroke width as the sole setting, synchronizing with
//  NSUserDefaults.
//
//  Created by Josef Lange on 2/19/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EXDrawSettingsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISlider *strokeWidthSlider;
@property (weak, nonatomic) IBOutlet UILabel *strokeWidthLabel;
@property (weak, nonatomic) IBOutlet UIButton *saveSettingsButton;
@property (strong, nonatomic) UIPopoverController *popoverController;


-(IBAction)saveSettings:(id)sender;
-(IBAction)strokeWidthDidChange:(UISlider *)strokeWidthSlider;

@end
