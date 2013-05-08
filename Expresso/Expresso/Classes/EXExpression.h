//
//  EXExpression.h
//  Expresso
//
//  Created by Josef Lange on 2/26/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EXDrawing.h"
#import "EXSymbol.h"

/**
 *  This class represents an expression: the image drawn, Barista's
 *  expression_identifier, and an array of EXSymbol objects.
 */

@interface EXExpression : NSObject

/** An NSNumber to hold onto Barista's expression_identifier. */
@property (strong, nonatomic) NSNumber *expressionIdentifier;
/** An NSArray object containing EXSymbol objects. */
@property (strong, nonatomic) NSArray *symbols;
/** The UIImage representation of the drawing. */
@property (strong, nonatomic) UIImage *image;
/** An NSArray containing likely equations. */
@property (strong, nonatomic) NSArray *equations;


/**
 * Set the expression's symbols with an array of NSDictionaries,
 * containing the formerly-JSONified data.
 *
 * @param symbols An array of NSDictionaries containing symbol data.
 */
-(void)setSymbolsWithArrayOfDicts:(NSArray *)symbols;

@end