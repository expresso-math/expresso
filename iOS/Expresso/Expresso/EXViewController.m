//
//  EXViewController.m
//  Expresso
//
//  Created by Josef Lange on 2/6/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import "EXViewController.h"

@interface EXViewController ()

@property (nonatomic, strong) UIPopoverController *settingsPopoverController;

@end

@implementation EXViewController

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortrait);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.strokeWidthSlider.minimumValue = 1.0;
    self.strokeWidthSlider.maximumValue = 10.0;
    self.strokeWidthSlider.value = 1.0;
    self.strokeWidthLabel.text = @"Stroke Width: 1";
    self.settingsPopoverController = [[UIPopoverController alloc] init];
    self.settingsPopoverController.popoverContentSize = CGSizeMake(320., 320.);
    //self.settingsPopoverController.delegate = self;
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMainView:nil];
    [self setDrawingView:nil];
    [self setStrokeWidthSlider:nil];
    [self setStrokeWidthLabel:nil];
    [super viewDidUnload];
}
- (IBAction)strokeWidthChanged:(UISlider *)sender {
    NSNumber *newValue = [NSNumber numberWithFloat:sender.value];
    NSNumber *newValueInt = [NSNumber numberWithInt:[newValue intValue]];
    self.drawingView.strokeWidth = newValueInt;
    self.strokeWidthLabel.text = [NSString stringWithFormat:@"Stroke Width: %d",
                             [newValueInt intValue]];
}
- (IBAction)clearDrawing:(id)sender {
    [self.drawingView eraseView];
}

- (IBAction)showPopoverFromButton:(id)sender {
    UIButton *button = (UIButton *)sender;
    [self.settingsPopoverController presentPopoverFromRect:button.frame
                                                    inView:self.view
                                  permittedArrowDirections:UIPopoverArrowDirectionAny
                                                  animated:YES];
    

}
@end
