//
//  EXSymbol
//  Expresso
//
//  Created by Josef Lange on 2/27/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  This class describes a recognized symbol. Its bounding box is a trivial
 *  property, but its self.charactersWithCertainty is a bit more complex:
 *  It's a dictionary whose keys are specific symbols (1, x, pi, sqrt, etc)
 *  and whose values are floating-point "scores" of how likely they are to be
 *  a match.
 */
@interface EXSymbol : NSObject

/** The symbol's identifier. */
@property (strong, nonatomic) NSNumber *symbolIdentifier;

/** The box that bounds the identified symbol. */
@property (readwrite, nonatomic) CGRect boundingBox;
/** 
 *  A dictionary of symbols and their certainty scores.
 *      - Symbols are keys, encoded and most of which are the actual letters or numbers
 *      - Scores are values, floating-point numbers, 0.0-1.0.
 */
@property (strong, nonatomic) NSDictionary *symbolsWithCertainty;

- (NSString *)mostCertainSymbol;
- (void)correctToValue:(NSString *)newValue;

@end

