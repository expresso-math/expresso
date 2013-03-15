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

#pragma mark - Initializers

/**
 *  Create new EXSession object with the given URL.
 *
 *  @param url The URL to attach to.
 */
-(id)initWithURL:(NSURL *)url {
    
    self = [super init];
    
    if (self) {
        self.apiURL = url;
    }
    
    return self;
    
}

#pragma mark - Propery Instantiation

/**
 *  Lazy instantiation for NSArray expressions
 *
 *  @return The expressions array, initialized.
 */
-(NSArray *)expressions {
    if(!_expressions) {
        _expressions = [[NSArray alloc] init];
    }
    return _expressions;
}

#pragma mark - Advanced State Manipulation

/**
 *  Add an expression to the local object.
 *
 *  Does not add to Barista's representation of the session.
 *
 *  @param expression The expression to add.
 */
-(void)addExpression:(EXExpression *)expression {
    self.expressions = [self.expressions arrayByAddingObject:expression];
    self.currentExpression = expression;
}

#pragma mark - Request Methods

#pragma mark >> Session Requests

/**
 *  Message from a View Controller for the session to start (connect).
 *
 *  We need the sender so we can issue events to it when the asynchronous
 *  request completes or fails.
 *
 *  @param sender The sender of the method call.
 */
-(void)startSessionFrom:(id)sender {
        
    // Create request. Send request. Get response. Fill in sessionIdentifier.
    NSURL *requestURL = [self.apiURL URLByAppendingPathComponent:@"session"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:requestURL];
    [request setDelegate:sender];
    [request setDidFinishSelector:@selector(receiveSession:)];
    [request setDidFailSelector:@selector(sessionFailed:)];
    [request startAsynchronous];
    
}

/**
 *  Like startSessionFrom: but with a sender-specified identifier.
 *
 *  Good for recovering old sessions or for recovering sessions from other machines.
 *
 *  @param  identifier  The identifier to fetch.
 *  @param  sender  The sender of the method call.
 */
-(void)startSessionWithSessionIdentifier:(NSString *)identifier from:(id)sender {
    
    // Create request. Send request. Get response. Fill in sessionIdentifier.
    NSURL *requestURL = [[self.apiURL URLByAppendingPathComponent:@"session"] URLByAppendingPathComponent:identifier];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:requestURL];
    [request setDelegate:sender];
    [request setDidFinishSelector:@selector(receiveSession:)];
    [request setDidFailSelector:@selector(sessionFailed:)];
    [request startAsynchronous];

}

#pragma mark >> Expression Requests

/**
 *  Get a new expression using this session.
 *
 *  @param sender The sender of the method call.
 */
-(void)getNewExpressionFrom:(id)sender {
    NSURL *requestURL = [[self.apiURL URLByAppendingPathComponent:self.sessionIdentifier] URLByAppendingPathComponent:@"expression"];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:requestURL];
    [request setDelegate:sender];
    [request setDidFinishSelector:@selector(receiveNewExpression:)];
    [request setDidFailSelector:@selector(newExpressionFailed:)];
    [request startAsynchronous];
}

#pragma mark >> Image Posts & Requests

/**
 *  Upload the given image to Barista using this session and the current expression.
 *
 *  @param  image   The image to upload.
 *  @param  sender The sender of the method call.
 */
-(void)uploadImage:(UIImage *)image from:(id)sender {
    
    NSURL *url = [[[self.apiURL URLByAppendingPathComponent:@"expression"] URLByAppendingPathComponent:[self.currentExpression.expressionIdentifier stringValue]] URLByAppendingPathComponent:@"image"];
    NSData *imageData = UIImagePNGRepresentation(image);
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setData:imageData withFileName:@"img.png" andContentType:@"image/png" forKey:@"image"];
    [request setDelegate:sender];
    [request setDidFinishSelector:@selector(imageUploadFinished:)];
    [request setDidFailSelector:@selector(imageUploadFailed:)];
    [request setUploadProgressDelegate:sender];
    [request startAsynchronous];
    self.currentExpression.image = image;
    
}

#pragma mark >> Symbol Requests

/**
 *  Get the symbol set from the API for this session's currentExpression.
 *
 *  @param sender The sender of the method call.
 */
-(void)getSymbolsFrom:(id)sender {
    
    NSURL *url = [[[self.apiURL URLByAppendingPathComponent:@"expression"] URLByAppendingPathComponent:[self.currentExpression.expressionIdentifier stringValue]] URLByAppendingPathComponent:@"symbolset"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request setDelegate:sender];
    [request setDidFinishSelector:@selector(receiveSymbols:)];
    [request setDidFailSelector:@selector(symbolsFailed:)];
    
    [request startAsynchronous];
    
}

@end
