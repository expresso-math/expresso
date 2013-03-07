//
//  EXAPIManager.m
//  Expresso
//
//  Created by Josef Lange on 3/5/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import "EXAPIManager.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@implementation EXAPIManager

+(EXAPIManager *)sharedManager {
    static dispatch_once_t pred;
    static EXAPIManager *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[EXAPIManager alloc] init];
        shared.apiURL = [NSURL URLWithString:@"http://expresso-api.heroku.com"];
        shared.sessionID = nil;
        [[NSNotificationCenter defaultCenter] addObserver:shared selector:@selector(createSession:) name:@"sessionRequestFinished" object:nil];
    });
    return shared;
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
    EXAPIManager *shared = [EXAPIManager sharedManager];
    NSData *data = [(ASIHTTPRequest *)[notification.userInfo valueForKey:@"request"] responseData];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    shared.sessionID = [dict valueForKey:@"session_name"];
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

- (void)sendImage:(UIImage *)image forExpression:(NSString *)expression {
    NSURL *url = [[[self.apiURL URLByAppendingPathComponent:@"expression"] URLByAppendingPathComponent:expression] URLByAppendingPathComponent:@"image"];
    NSData *imageData = UIImagePNGRepresentation(image);
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"imageUpload" forKey:@"action"];
    [request setUserInfo:userInfo];
    [request setData:imageData withFileName:@"img.png" andContentType:@"image/png" forKey:@"image"];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)getSymbolSetForExpression:(NSString *)expression {
    NSURL *url = [[[self.apiURL URLByAppendingPathComponent:@"expression"] URLByAppendingPathComponent:expression] URLByAppendingPathComponent:@"symbolset"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.userInfo = [NSDictionary dictionaryWithObject:@"getSymbolSet" forKey:@"action"];
    request.delegate = self;
    [request startAsynchronous];
}

@end
