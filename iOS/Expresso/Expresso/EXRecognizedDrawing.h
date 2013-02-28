//
//  EXRecognizedDrawing.h
//  Expresso
//
//  Created by Josef Lange on 2/26/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EXDrawing.h"
#import "EXRecognizedCharacter.h"

@interface EXRecognizedDrawing : NSObject

@property (strong, nonatomic, readonly) NSNumber *drawingID;
@property (strong, nonatomic) NSArray *characters;
@property (strong, nonatomic) UIImage *image;

@end