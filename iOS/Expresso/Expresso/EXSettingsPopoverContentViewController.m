//
//  EXSettingsPopoverContentViewController.m
//  Expresso
//
//  Created by Josef Lange on 2/14/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import "EXSettingsPopoverContentViewController.h"
#import "EXViewController.h"

@interface EXSettingsPopoverContentViewController ()

@end

@implementation EXSettingsPopoverContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    // Get stroke width from main controller.
    self.strokeWidthSlider.minimumValue = 1.0;
    self.strokeWidthSlider.maximumValue = 10.0;
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
 *  Respond to changing of the stroke width slider. Sets the property in the drawing
 *  view and updates the label next to the slider.
 */
- (IBAction)strokeWidthChanged:(UISlider *)sender {
    NSNumber *newValue = [NSNumber numberWithFloat:sender.value];
    NSNumber *newValueInt = [NSNumber numberWithInt:[newValue intValue]];
    NSNotificationCenter *n = [NSNotificationCenter defaultCenter];
    NSNotification *notification = [NSNotification notificationWithName:@"strokeWidthDidChange"
                                                                 object:self
                                    userInfo:[NSDictionary dictionaryWithObject:newValueInt forKey:@"newStrokeWidth"]];
    [n postNotification:notification];
    self.strokeWidthLabel.text = [NSString stringWithFormat:@"Stroke Width: %d", [newValueInt intValue]];
}

-(void)updateStrokeWidthUI:(NSNumber *)newStrokeWidth {
    NSString *newLabel = [NSString stringWithFormat:@"Stroke Width: %d", [newStrokeWidth intValue]];
    self.strokeWidthSlider.value = [newStrokeWidth floatValue];
    self.strokeWidthLabel.text = newLabel;
}

@end
