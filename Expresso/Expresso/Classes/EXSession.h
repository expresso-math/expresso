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

/**
 *  Model-like class that holds onto basic session information (and 
 *  communicates with Barista to change/update it RESTfully. Also does a
 *  couple tasks not dependent on an active session, particularly submitting
 *  training sets.
 */

@interface EXSession : NSObject

/** The identifier used by Barista to keep track of this session */
@property (strong, nonatomic) NSString  *sessionIdentifier;

/** The URL of the API being called. */
@property (strong, nonatomic) NSURL     *apiURL;

/** An array of expressions associated with this session, lazily instantiated. */
@property (readonly, nonatomic) NSArray   *expressions;

/** The current working expression (or a pointer to it, at least and not a copy). */
@property (readonly, nonatomic) EXExpression *currentExpression;

/**
 *  Create new EXSession object with the given URL.
 *
 *  @param url The URL to attach to.
 */
-(id)initWithURL:(NSURL *)url;

/**
 *  Message from a View Controller for the session to start (connect).
 *  
 *  We need the sender so we can issue events to it when the asynchronous
 *  request completes or fails.
 *
 *  @param sender The sender of the method call.
 */
-(void)startSessionFrom:(id)sender;

/**
 *  Like startSessionFrom: but with a sender-specified identifier. 
 *
 *  Good for recovering old sessions or for recovering sessions from other machines.
 *
 *  @param  identifier  The identifier to fetch.
 *  @param  sender  The sender of the method call.
 */
-(void)startSessionWithSessionIdentifier:(NSString *)identifier from:(id)sender;

/**
 *  Get a new expression using this session.
 *
 *  @param sender The sender of the method call.
 */
-(void)getNewExpressionFrom:(id)sender;

/**
 *  Upload the given image to Barista using this session and the current expression.
 *
 *  @param  image   The image to upload.
 *  @param  sender The sender of the method call.
 */
-(void)uploadImage:(UIImage *)image from:(id)sender;

/**
 *  Get the symbol set from the API for this session's currentExpression.
 *
 *  @param sender The sender of the method call.
 */
-(void)getSymbolsFrom:(id)sender;

/**
 *  Take the array of symbols and use their data to update Barista.
 *
 *  @param  array   The array of symbols.
 *  @param  sender  The sender of the message.
 */
-(void)updateSymbolsWithArray:(NSArray *)array from:(id)sender;

/**
 *  Get estimate equations from Barista.
 *
 *  @param  sender  The sender of the message.
 */
-(void)getEquationsFrom:(id)sender;

/**
 *  Get equation image for a given identifier. Right now a fake ID.
 *
 *
 **/
-(UIImage *)getEquationImageForIdentifier:(NSString *)identifier;

/**
 *  Add an expression to the local object. 
 *
 *  Does not add to Barista's representation of the session.
 *
 *  @param expression The expression to add.
 */
-(void)addExpression:(EXExpression *)expression;

/**
 *  Get a symbol that Barista wants the user to generate a training set for.
 *
 *  @return The symbol, as a string.
 */
+(NSString *)getSymbolForTraining;

/**
 *  Upload an image for training, for the given symbol, from the given ViewController.
 *
 *  @param  image   The UIImage of the training image.
 *  @param  symbol  The symbol we're training.
 *  @param  sender  The ViewController who sent the message.
 */
+(void)uploadTrainingImage:(UIImage *)image forSymbol:(NSString *)symbol from:(id)sender;

@end
