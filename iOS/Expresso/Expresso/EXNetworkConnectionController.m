//
//  EXNetworkConnectionController.m
//  Expresso
//
//  Created by Josef Lange on 2/26/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import "EXNetworkConnectionController.h"

@implementation EXNetworkConnectionController


- (id)init {
    self = [super init];
    
    if(self) {
        
        NSURL *baseURL = [NSURL URLWithString:@"http://expresso-api.herokuapp.com"];
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
        [httpClient setDefaultHeader:@"Accept" value:RKMIMETypeJSON];
        
        RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:httpClient];
        
    }
    
    return self;
}

@end