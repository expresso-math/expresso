//
//  EXSymbolCorrectionViewController.h
//  Expresso
//
//  Created by Josef Lange on 4/11/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EXSymbol.h"

@interface EXSymbolCorrectionViewController : UIViewController

@property (strong, nonatomic) EXSymbol *symbol;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *symbolLabel;
@property (weak, nonatomic) IBOutlet UITextView *symbolText;
@property (strong, nonatomic) NSString *setSymbol;
@property (strong, nonatomic) UIImage *image;
@property (weak, nonatomic) UIPopoverController *pop;

-(IBAction)saveSymbol:(id)sender;

@end
