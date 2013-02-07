//
//  EXViewController.m
//  Expresso
//
//  Created by Josef Lange on 2/6/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import "EXViewController.h"

@interface EXViewController ()

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
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMainView:nil];
    //[self setDrawingView:nil];
    [self setStrokeWidthSlider:nil];
    [super viewDidUnload];
}
- (IBAction)strokeWidthChanged:(UISlider *)sender {
    self.drawingView.stroke = [NSNumber numberWithFloat:sender.value];
    [self.mainView bringSubviewToFront:self.drawingView];
}
@end
