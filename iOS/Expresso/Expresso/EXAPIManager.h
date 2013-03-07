//
//  EXAPIManager.h
//  Expresso
//
//  Created by Josef Lange on 3/5/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@interface EXAPIManager : NSObject <ASIHTTPRequestDelegate>

@property (strong, nonatomic) NSURL *apiURL;
@property (strong, nonatomic) NSString *sessionID;

+ (EXAPIManager *)sharedManager;

- (void)startSession;
- (void)createSession:(NSNotification *)notification;
- (NSString *)getNewExpression;
- (void)sendImage:(UIImage *)image forExpression:(NSString *)expression;
- (void)getSymbolSetForExpression:(NSString *)expression;

@end
