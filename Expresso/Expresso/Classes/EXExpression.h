//
//  EXRecognizedDrawing.h
//  Expresso
//
//  Created by Josef Lange on 2/26/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EXDrawing.h"
#import "EXSymbol.h"

@interface EXExpression : NSObject

@property (strong, nonatomic) NSString *expressionIdentifier;
@property (strong, nonatomic) NSArray *symbols;
@property (strong, nonatomic) UIImage *image;

-(void)setSymbolsWithArray:(NSArray *)symbols;

@end