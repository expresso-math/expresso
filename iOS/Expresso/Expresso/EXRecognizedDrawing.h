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

@interface EXRecognizedDrawing : EXDrawing

@property (strong, nonatomic, readonly) NSNumber *drawingID;
@property (strong, nonatomic) NSDictionary *characters;
// Already has NSArray for drawnPaths from superclass.

@end