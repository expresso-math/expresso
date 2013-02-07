//
//  EXDataViewController.m
//  Expresso
//
//  Created by Josef Lange on 2/6/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import "EXDataViewController.h"

@interface EXDataViewController ()

@end

@implementation EXDataViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.dataLabel.text = [self.dataObject description];
}

@end
