//
//  EXAPIManager.m
//  Expresso
//
//  Created by Josef Lange on 3/5/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import "EXAPIManager.h"
#import "ASIHTTPRequest.h"

@implementation EXAPIManager

+ (EXAPIManager *)sharedAPIManager
{
    static dispatch_once_t pred = 0;
    __strong static EXAPIManager *sharedObject = nil;
    dispatch_once(&pred, ^{
        sharedObject = [[self alloc] init]; // or some other init method
        sharedObject.apiURL = [NSURL URLWithString:@"http://localhost:5000"];
        sharedObject.sessionID = nil;
        [[NSNotificationCenter defaultCenter] addObserver:sharedObject selector:@selector(createSession:) name:@"sessionRequestFinished" object:nil];
    });
    return sharedObject;
}

- (void)startSession {
    NSURL *getSessionURL = [self.apiURL URLByAppendingPathComponent:@"session"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:getSessionURL];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"sessionRequest" forKey:@"action"];
    [request setUserInfo:userInfo];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)createSession:(NSNotification *)notification {
   
}

- (NSString *)getNewExpression {
    NSString *returnString = nil;
    NSURL *getExpressionURL = [self.apiURL URLByAppendingPathComponent:self.sessionID];
    getExpressionURL = [getExpressionURL URLByAppendingPathComponent:@"expression"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:getExpressionURL];
    [request startSynchronous];
    NSError *error = request.error;
    if(!error) {
        NSData *responseData = request.responseData;
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        returnString = [responseDictionary valueForKey:@"expression_id"];
    } else {
        returnString = @"Error";
    }
    NSLog(@"%@", returnString);
    return returnString;
}

- (void)requestStarted:(ASIHTTPRequest *)request
{
    NSDictionary *requestDict = [NSDictionary dictionaryWithObject:request forKey:@"request"];
    // Handle request start stuff here.
    NSString *notificationName = [(NSString *)[request.userInfo valueForKey:@"action"] stringByAppendingString:@"Started"];
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:self userInfo:requestDict];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    //    NSString *responseString = [request responseString];
    
    // Use when fetching binary data
    NSDictionary *responseDict = [NSDictionary dictionaryWithObject:request forKey:@"request"];
    
    NSString *notificationName = [(NSString *)[request.userInfo valueForKey:@"action"] stringByAppendingString:@"Finished"];
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:self userInfo:responseDict];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSDictionary *errorDict = [NSDictionary dictionaryWithObject:request forKey:@"request"];
    
    NSString *notificationName = [(NSString *)[request.userInfo valueForKey:@"action"] stringByAppendingString:@"Failed"];
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:self userInfo:errorDict];
}

@end
