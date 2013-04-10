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

// (Documented in header file)
-(id)initWithURL:(NSURL *)url {
    
    self = [super init];
    
    if (self) {
        self.apiURL = url;
    }
    
    return self;
    
}

#pragma mark - Propery Instantiation

-(NSArray *)expressions {
    if(!_expressions) {
        _expressions = [[NSArray alloc] init];
    }
    return _expressions;
}

#pragma mark - Advanced State Manipulation

// (Documented in header file)
-(void)addExpression:(EXExpression *)expression {
    self.expressions = [self.expressions arrayByAddingObject:expression];
    self.currentExpression = expression;
}

#pragma mark - Request Methods

#pragma mark >> Session Requests

// (Documented in header file)
-(void)startSessionFrom:(id)sender {
        
    // Create request. Send request. Get response. Fill in sessionIdentifier.
    NSURL *requestURL = [self.apiURL URLByAppendingPathComponent:@"session"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:requestURL];
    [request setDelegate:sender];
    [request setDidFinishSelector:@selector(receiveSession:)];
    [request setDidFailSelector:@selector(sessionFailed:)];
    [request startAsynchronous];
    
}

// (Documented in header file)
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

// (Documented in header file)
-(void)getNewExpressionFrom:(id)sender {
    NSURL *requestURL = [[self.apiURL URLByAppendingPathComponent:self.sessionIdentifier] URLByAppendingPathComponent:@"expression"];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:requestURL];
    [request setDelegate:sender];
    [request setDidFinishSelector:@selector(receiveNewExpression:)];
    [request setDidFailSelector:@selector(newExpressionFailed:)];
    [request startAsynchronous];
}

#pragma mark >> Image Posts & Requests

// (Documented in header file)
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

// (Documented in header file)
-(void)getSymbolsFrom:(id)sender {
    
    NSURL *url = [[[self.apiURL URLByAppendingPathComponent:@"expression"] URLByAppendingPathComponent:[self.currentExpression.expressionIdentifier stringValue]] URLByAppendingPathComponent:@"symbolset"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request setTimeOutSeconds:30];
    
    [request setDelegate:sender];
    [request setDidFinishSelector:@selector(receiveSymbols:)];
    [request setDidFailSelector:@selector(symbolsFailed:)];
    
    [request startAsynchronous];
    
}

// (Documented in header file)
+(NSString *)getSymbolForTraining {
    NSString *serverHost = [[NSUserDefaults standardUserDefaults] objectForKey:@"serverHost"];
    NSString *stringURL = [serverHost stringByAppendingString:@"trainer"];
    NSURL *url = [NSURL URLWithString:stringURL];
    //NSURL *url = [NSURL URLWithString:@"http://localhost:5000/trainer"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    
    // Get Dictionary of the data.
    NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:request.responseData
                                                                 options:NSJSONReadingAllowFragments
                                                                   error:nil];
    int ascii = [[responseData objectForKey:@"symbol"] intValue];
    return [NSString stringWithFormat:@"%c", ascii];
}

+(void)uploadTrainingImage:(UIImage *)image forSymbol:(NSString *)symbol from:(id)sender {
    NSString *serverHost = [[NSUserDefaults standardUserDefaults] objectForKey:@"serverHost"];
    NSString *stringURL = [serverHost stringByAppendingString:@"trainer"];
    NSURL *url = [NSURL URLWithString:stringURL];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    NSData *imageData = UIImagePNGRepresentation(image);
    unichar ascii = [symbol characterAtIndex:0];
    [request setData:imageData withFileName:@"img.png" andContentType:@"image/png" forKey:@"image"];
    [request addPostValue:[NSNumber numberWithInt:ascii] forKey:@"symbol"];
    [request setUploadProgressDelegate:sender];
    [request setDelegate:sender];
    [request setDidFinishSelector:@selector(imageUploaded:)];
    [request startAsynchronous];
}

@end
