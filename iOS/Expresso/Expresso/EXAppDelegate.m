//
//  EXAppDelegate.m
//  Expresso
//
//  Created by Josef Lange on 2/6/13.
//  Copyright (c) 2013 Josef Lange & Daniel Guilak. All rights reserved.
//

#import "EXAppDelegate.h"
#import <DropboxSDK/DropboxSDK.h> // DropBox!

@interface EXAppDelegate()

@end

@implementation EXAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Set up our DropBox session.
    DBSession* dbSession =
    [[DBSession alloc] initWithAppKey:@"d4a7k2jd3z0szpw"    // SEKRET!
                            appSecret:@"xva2joc7r5v08ms"    // MORE SEKRET!
                                 root:kDBRootDropbox];
    [DBSession setSharedSession:dbSession]; // Set shared session.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
 *  Capture the link activation from the DropBox app or website once the user has
 *  OK'd our app's access.
 *
 */
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    if ([[DBSession sharedSession] handleOpenURL:url]) {
        if ([[DBSession sharedSession] isLinked]) {
            NSLog(@"App linked successfully!");
            // At this point you can start making API calls
        }
        return YES;
    }
    // Add whatever other url handling code your app requires here
    // DON'T FORGET: THERE'S A SETTING IN THE INFO.PLIST THAT SETS UP THIS APP FOR
    // ACCEPTING A SPECIFIC URL. CLEAR IT WHEN DONE WITH DB STUFF.
    return NO;
}

@end
