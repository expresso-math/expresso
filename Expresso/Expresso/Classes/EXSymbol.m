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

- (NSString *)mostCertainSymbol {
    NSString *returner = @"a";
    
    NSArray *descending = [self.symbolsWithCertainty keysSortedByValueUsingSelector:@selector(localizedStandardCompare:)];
    
    NSLog(@"%@", descending);
    
    return returner;
}

@end
