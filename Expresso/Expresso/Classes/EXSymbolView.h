//
//  EXSymbolView.h
//  Expresso
//
//  Created by Josef Lange on 3/7/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EXSymbol.h"

/**
 *  This class is a neat little view that takes a frame on initialization
 *  and makes a handsome rounded-rect with a label in the upper-left corner.
 */
@interface EXSymbolView : UIControl

/** The label showing the proposed symbol. */
@property (strong, nonatomic) UILabel *symbolLabel;
/** Pointer (weak) to the symbol we represent. */
@property (weak, nonatomic) EXSymbol *symbol;
/** Pointer (strong) to our delegate that will receive programmatically-assigned target actions. */
@property (assign, nonatomic) id delegate;

-(void)setNewSymbol:(EXSymbol *)symbol;

@end
