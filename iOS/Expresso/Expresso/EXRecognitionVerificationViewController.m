//
//  EXRecognitionVerificationViewController.m
//  Expresso
//
//  Created by Josef Lange on 2/27/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import "EXRecognitionVerificationViewController.h"
#import "EXRecognizedCharacterView.h"
#import "EXAPIManager.h"
#import <QuartzCore/QuartzCore.h>

@interface EXRecognitionVerificationViewController()

@property (readwrite, nonatomic) BOOL boundingBoxesShowing;

@end

@implementation EXRecognitionVerificationViewController

@synthesize imageView = _imageView;
@synthesize expression = _expression;
@synthesize boundingBoxes = _boundingBoxes;
@synthesize boundingBoxesShowing = _boundingBoxesShowing;

/*
 *  Help force landscape.
 */
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortrait);
}

- (EXRecognizedExpression *)expression {
    if(!_expression ) {
        _expression = [[EXRecognizedExpression alloc] init];
    }
    return _expression;
}

- (NSArray *)boundingBoxes {
    if(!_boundingBoxes ) {
        _boundingBoxes = [[NSArray alloc] init];
    }
    return _boundingBoxes;

}

- (void)viewDidLoad {
    
    self.imageView.image = self.expression.image;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadStarted:) name:@"imageUploadStarted" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadFailed:) name:@"imageUploadFailed" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadFinished:) name:@"imageUploadFinished" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSymbolSetFinished:) name:@"getSymbolSetFinished" object:nil];
     
     EXAPIManager *manager = [EXAPIManager sharedManager];
     self.expression.expressionID = [manager getNewExpression];
     [manager sendImage:self.expression.image forExpression:self.expression.expressionID];
    
    [[self.hud layer] setCornerRadius:5.0];
    [[self.hud layer] setMasksToBounds:YES];
    
    self.boundingBoxesShowing = NO;

}

- (void)uploadStarted:(NSNotification *)notification {
    ASIHTTPRequest *request = (ASIHTTPRequest *)[[notification userInfo] objectForKey:@"request"];
    [request setUploadProgressDelegate:self.hud.bar];
    [self.hud.cog setHidden:YES];
    [self.hud.label setText:@"Uploading..."];
    [self showHUD];
}

- (void)uploadFailed:(NSNotification *)notification {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)uploadFinished:(NSNotification *)notification {
    [self.hud showCog];
    self.hud.label.text = @"Processing...";
    EXAPIManager *manager = [EXAPIManager sharedManager];
    [manager getSymbolSetForExpression:self.expression.expressionID];
}

- (void)getSymbolSetFinished:(NSNotification *)notification {
    [UIView animateWithDuration:0.3 animations:^{
        self.hud.alpha = 0.0;
        self.hud.hidden = YES;
    }];
    NSData *data = [(ASIHTTPRequest *)[notification.userInfo valueForKey:@"request"] responseData];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSArray *symbols = [dict valueForKey:@"symbols"];
    
    [self.expression setSymbolsWithArray:symbols];
    
    EXRecognizedSymbol *symbol;
    NSArray *symbolSet = self.expression.symbols;
    for (symbol in symbolSet) {
        EXRecognizedCharacterView *newView = [[EXRecognizedCharacterView alloc] initWithFrame:symbol.boundingBox];
        self.boundingBoxes = [self.boundingBoxes arrayByAddingObject:newView];
    }
    
    [self showBoundingBoxes];
    }

- (IBAction)toggleBoundingBoxes:(id)sender {
    if(self.boundingBoxesShowing) {
        [self hideBoundingBoxes];
    } else {
        [self showBoundingBoxes];
    }
}

- (void)showBoundingBoxes {
    UIView *view;
    for (view in self.boundingBoxes) {
        [self.view addSubview:view];
    }
    self.boundingBoxesShowing = YES;
}

- (void)hideBoundingBoxes {
    UIView *view;
    for (view in self.boundingBoxes) {
        [view removeFromSuperview];
    }
    self.boundingBoxesShowing = NO;
    
}

- (void)showHUD {
    self.hud.alpha = 0;
    self.hud.hidden = NO;
    [self.hud showBar];
    [UIView animateWithDuration:0.3 animations:^{
        self.hud.alpha = 0.9;
    }];
}

@end
