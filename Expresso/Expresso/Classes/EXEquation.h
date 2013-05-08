//
//  EXEquation.h
//  Expresso
//
//  Created by Josef Lange on 5/3/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EXEquation : NSObject

@property (strong, nonatomic) NSNumber *equationIdentifier;
@property (strong, nonatomic) NSString *latexEncoding;
@property (strong, nonatomic) UIImage *equationImage;

@end
