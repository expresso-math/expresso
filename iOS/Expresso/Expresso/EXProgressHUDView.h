//
//  EXProgressHUDView.h
//  Expresso
//
//  Created by Josef Lange on 3/7/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EXProgressHUDView : UIView

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *cog;
@property (weak, nonatomic) IBOutlet UIProgressView *bar;
@property (weak, nonatomic) IBOutlet UILabel *label;

-(void)showBar;
-(void)showCog;

@end
