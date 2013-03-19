//
//  EXRecognizedDrawing.m
//  Expresso
//
//  Created by Josef Lange on 2/26/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import "EXExpression.h"

@implementation EXExpression

@synthesize expressionIdentifier = _expressionIdentifier;
@synthesize symbols = _symbols;
@synthesize image = _image;

#pragma mark - Advanced State Manipulation

// (Documented in header file)
-(void)setSymbolsWithArrayOfDicts:(NSArray *)symbols {
    NSDictionary *symbol;
    NSMutableArray *newSymbolSet = [NSMutableArray arrayWithCapacity:20];
    for (symbol in symbols) {
        NSArray *box = [symbol valueForKey:@"box"];
        NSDictionary *symbols = [symbol valueForKey:@"characters"];
        CGFloat x = [[box objectAtIndex:0] doubleValue];
        CGFloat y = [[box objectAtIndex:1] doubleValue];
        CGFloat w = [[box objectAtIndex:2] doubleValue];
        CGFloat h = [[box objectAtIndex:3] doubleValue];
        CGRect boundingBox = CGRectMake(x,y,w,h);
        EXSymbol *newSymbol = [[EXSymbol alloc] init];
        [newSymbol setSymbolsWithCertainty:symbols];
        [newSymbol setBoundingBox:boundingBox];
        [newSymbolSet addObject:newSymbol];
    }
    self.symbols = [newSymbolSet copy];
}

@end
