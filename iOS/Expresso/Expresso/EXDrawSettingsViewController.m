//
//  EXDrawSettingsPopoverController.m
//  Expresso
//
//  Created by Josef Lange on 2/19/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import "EXDrawSettingsViewController.h"
#import "EXAppDelegate.h"
#import "UIButton+Glossy.h"


@implementation EXDrawSettingsViewController

@synthesize strokeWidthLabel = _strokeWidthLabel;
@synthesize strokeWidthSlider = _strokeWidthSlider;
@synthesize saveSettingsButton = _saveSettingsButton;
@synthesize popoverController = _myPopoverController;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.strokeWidthSlider.minimumValue = 1.0;
    self.strokeWidthSlider.maximumValue = 10.0;
    NSNumber *newStrokeWidth = [[NSUserDefaults standardUserDefaults] valueForKey:@"strokeWidth"];
    self.strokeWidthSlider.value = [newStrokeWidth floatValue];
    self.strokeWidthLabel.text = [NSString stringWithFormat:@"Stroke Width: %d", [newStrokeWidth intValue]];

	// Do any additional setup after loading the view.
    [self.saveSettingsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.saveSettingsButton makeGlossy];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)saveSettings:(id)sender {
    [[NSUserDefaults standardUserDefaults] synchronize];
    // Close popover.
    [self.popoverController dismissPopoverAnimated:YES];
}

-(IBAction)strokeWidthDidChange:(UISlider *)sender {
    NSNumber *newValue = [NSNumber numberWithFloat:sender.value];
    newValue = [NSNumber numberWithInt:[newValue intValue]];
    [[NSUserDefaults standardUserDefaults] setObject:newValue forKey:@"strokeWidth"];
    self.strokeWidthLabel.text = [NSString stringWithFormat:@"Stroke Width: %d", [newValue intValue]];
}



@end
