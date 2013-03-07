//
//  EXRecognizedDrawing.m
//  Expresso
//
//  Created by Josef Lange on 2/26/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import "EXRecognizedExpression.h"

@implementation EXRecognizedExpression

@synthesize expressionID = _expressionID;
@synthesize symbols = _symbols;
@synthesize image = _image;


-(void)setSymbolsWithArray:(NSArray *)symbols {
    NSDictionary *symbol;
    NSMutableArray *newSymbolSet = [NSMutableArray arrayWithCapacity:20];
    for (symbol in symbols) {
        NSArray *box = [symbol valueForKey:@"box"];
        NSDictionary *characters = [symbol valueForKey:@"characters"];
        CGFloat x = [[box objectAtIndex:0] doubleValue];
        CGFloat y = [[box objectAtIndex:1] doubleValue];
        CGFloat w = [[box objectAtIndex:2] doubleValue];
        CGFloat h = [[box objectAtIndex:3] doubleValue];
        CGRect boundingBox = CGRectMake(x,y,w,h);
        EXRecognizedSymbol *newSymbol = [[EXRecognizedSymbol alloc] init];
        [newSymbol setCharactersWithCertainty:characters];
        [newSymbol setBoundingBox:boundingBox];
        [newSymbolSet addObject:newSymbol];
    }
    self.symbols = [newSymbolSet copy];
    NSLog(@"SYMBOLSET: %@", self.symbols);
}
@end
