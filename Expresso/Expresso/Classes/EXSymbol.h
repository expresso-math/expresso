//
//  EXSymbol
//  Expresso
//
//  Created by Josef Lange on 2/27/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EXSymbol : NSObject

@property (readwrite, nonatomic) CGRect boundingBox;
@property (strong, nonatomic) NSDictionary *charactersWithCertainty;

@end

