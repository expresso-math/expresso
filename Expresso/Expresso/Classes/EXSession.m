//
//  EXSession.m
//  Expresso
//
//  Created by Josef Lange on 3/8/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import "EXSession.h"
#import "ASIFormDataRequest.h"

@interface EXSession()

@property (strong, nonatomic) NSArray *expressions;
@property (strong, nonatomic) EXExpression *currentExpression;

@end

@implementation EXSession

@synthesize sessionIdentifier = _sessionIdentifier;
@synthesize apiURL = _apiURL;
@synthesize expressions = _expressions;
@synthesize currentExpression = _currentExpression;

-(id)initWithURL:(NSURL *)url {
    
    self = [super init];
    
    if (self) {
        self.apiURL = url;
    }
    
    return self;
    
}

-(NSArray *)expressions {
    if(!_expressions) {
        _expressions = [[NSArray alloc] init];
    }
    return _expressions;
}

-(void)startSessionFrom:(id)sender {
        
    // Create request. Send request. Get response. Fill in sessionIdentifier.
    NSURL *requestURL = [self.apiURL URLByAppendingPathComponent:@"session"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:requestURL];
    [request setDelegate:sender];
    [request setDidFinishSelector:@selector(receiveSession:)];
    [request setDidFailSelector:@selector(sessionFailed:)];
    [request startAsynchronous];
    
}
-(void)startSessionWithSessionIdentifier:(NSString *)identifier from:(id)sender {
    
    // Create request. Send request. Get response. Fill in sessionIdentifier.
    NSURL *requestURL = [[self.apiURL URLByAppendingPathComponent:@"session"] URLByAppendingPathComponent:identifier];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:requestURL];
    [request setDelegate:sender];
    [request setDidFinishSelector:@selector(receiveSession:)];
    [request setDidFailSelector:@selector(sessionFailed:)];
    [request startAsynchronous];

}

-(void)getNewExpressionFrom:(id)sender {
    NSURL *requestURL = [[self.apiURL URLByAppendingPathComponent:self.sessionIdentifier] URLByAppendingPathComponent:@"expression"];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:requestURL];
    [request setDelegate:sender];
    [request setDidFinishSelector:@selector(receiveNewExpression:)];
    [request setDidFailSelector:@selector(newExpressionFailed:)];
    [request startAsynchronous];
}

- (void)uploadImage:(UIImage *)image withHud:(id)hud from:(id)sender {
    
    NSURL *url = [[[self.apiURL URLByAppendingPathComponent:@"expression"] URLByAppendingPathComponent:[self.currentExpression.expressionIdentifier stringValue]] URLByAppendingPathComponent:@"image"];
    NSData *imageData = UIImagePNGRepresentation(image);
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setData:imageData withFileName:@"img.png" andContentType:@"image/png" forKey:@"image"];
    [request setDelegate:sender];
    [request setDidFinishSelector:@selector(imageUploadFinished:)];
    [request setDidFailSelector:@selector(imageUploadFailed:)];
    [request setUploadProgressDelegate:hud];
    [request startAsynchronous];
    self.currentExpression.image = image;
    
}

- (void)getSymbolsFrom:(id)sender {
    
    NSURL *url = [[[self.apiURL URLByAppendingPathComponent:@"expression"] URLByAppendingPathComponent:[self.currentExpression.expressionIdentifier stringValue]] URLByAppendingPathComponent:@"symbolset"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request setDelegate:sender];
    [request setDidFinishSelector:@selector(receiveSymbols:)];
    [request setDidFailSelector:@selector(symbolsFailed:)];
    
    [request startAsynchronous];
    
}

- (void)addExpression:(EXExpression *)expression {
    self.expressions = [self.expressions arrayByAddingObject:expression];
    self.currentExpression = expression;
}

@end
