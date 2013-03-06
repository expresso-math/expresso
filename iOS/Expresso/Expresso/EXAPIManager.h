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

+ (EXAPIManager *)sharedAPIManager;

- (void)startSession;
- (void)createSession:(NSNotification *)notification;
- (NSString *)getNewExpression;

@end
