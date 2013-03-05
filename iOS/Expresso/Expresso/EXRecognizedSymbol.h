//
//  EXRecognizedCharacter.h
//  Expresso
//
//  Created by Josef Lange on 2/27/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EXRecognizedCharacter : NSObject

@property (assign, nonatomic) CGRect boundingBox;
@property (strong, nonatomic) NSDictionary *charactersWithCertainty;

@end
