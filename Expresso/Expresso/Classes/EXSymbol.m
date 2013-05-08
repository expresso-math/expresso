//
//  EXSymbol
//  Expresso
//
//  Created by Josef Lange on 2/27/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import "EXSymbol.h"

@implementation EXSymbol

@synthesize boundingBox = _boundingBox;
@synthesize symbolsWithCertainty = _symbolsWithCertainty;
@synthesize symbolIdentifier = _symbolIdentifier;

- (NSString *)mostCertainSymbol {
    NSString *returner = @"a";
    
    NSArray *descending = [self.symbolsWithCertainty keysSortedByValueUsingSelector:@selector(localizedStandardCompare:)];
    
    if ([descending objectAtIndex:0]) {
        returner = [descending objectAtIndex:0];
    }
    
    return returner;
    
}

- (void)correctToValue:(NSString *)newValue {
    self.symbolsWithCertainty = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:1.0] forKey:newValue];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"valueDidChange" object:self];
}

@end
