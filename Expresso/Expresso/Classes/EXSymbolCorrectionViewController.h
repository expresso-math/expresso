//
//  EXSymbolCorrectionViewController.h
//  Expresso
//
//  Created by Josef Lange on 4/11/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EXSymbol.h"

/**
 *  View Controller for modifying the identified representation of a symbol.
 */
@interface EXSymbolCorrectionViewController : UIViewController

/** The symbol we're modifying. */
@property (strong, nonatomic) EXSymbol *symbol;
/** The image view that holds the segment of the drawn image. */
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
/** The label for the symbol. */
@property (weak, nonatomic) IBOutlet UILabel *symbolLabel;
/** The text of a the representation of the symbol. */
@property (weak, nonatomic) IBOutlet UITextView *symbolText;
/** The current symbol we're set to. */
@property (strong, nonatomic) NSString *setSymbol;
/** The image we're displaying in imageView. */
@property (strong, nonatomic) UIImage *image;
/** The popover that presented this ViewController. */
@property (weak, nonatomic) UIPopoverController *pop;


/**
 *  Save the symbol's state and go away.
 *
 *  @param  sender  The object sending the message.
 */
-(IBAction)saveSymbol:(id)sender;

@end
