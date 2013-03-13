//
//  EXSession.h
//  Expresso
//
//  Created by Josef Lange on 3/8/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EXExpression.h"
#import "ASIHTTPRequest.h"

@interface EXSession : NSObject

@property (strong, nonatomic) NSString  *sessionIdentifier;
@property (strong, nonatomic) NSURL     *apiURL;
@property (readonly, nonatomic) NSArray   *expressions;
@property (readonly, nonatomic) EXExpression *currentExpression;

-(id)initWithURL:(NSURL *)url;
-(void)startSessionFrom:(id)sender;
-(void)startSessionWithSessionIdentifier:(NSString *)identifier from:(id)sender;
-(void)getNewExpressionFrom:(id)sender;
-(void)uploadImage:(UIImage *)image from:(id)sender;
-(void)getSymbolsFrom:(id)sender;
-(void)addExpression:(EXExpression *)expression;


@end
