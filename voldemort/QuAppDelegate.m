//
//  QuAppDelegate.m
//  voldemort
//
//  Created by  on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuAppDelegate.h"
#import "QuLoginController.h"

@implementation QuAppDelegate

@synthesize window = _window;
@synthesize devToken = _devToken;
@synthesize zmqContext = _zmqContext;
@synthesize reqSocket = _reqSocket;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    int major = 0;
    int minor = 0;
    int patch = 0;
    [ZMQContext getZMQVersionMajor:&major minor:&minor patch:&patch];
    self.zmqContext = [[ZMQContext alloc] initWithIOThreads:1];
    self.reqSocket = [self.zmqContext socketWithType:ZMQ_REQ];
    [self.reqSocket connectToEndpoint:[NSString stringWithFormat:@"tcp://%@:%d", @"10.0.2.11", 5566]];

    NSLog(@"%@",self.reqSocket);
    QuLoginController *root_controller = nil;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"device_email"]) {
        root_controller = [[QuLoginController alloc] initWithNibName:@"QuLoginController" bundle:nil];
    }
    else {
        root_controller = [[QuLoginController alloc] initWithNibName:@"QuLoginController" bundle:nil];
    }
    
    self.window.rootViewController = root_controller;
    [self.window makeKeyAndVisible];
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|
                                                                            UIRemoteNotificationTypeBadge|
     UIRemoteNotificationTypeSound];
    
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    self.devToken = [[[[deviceToken description] 
                            stringByReplacingOccurrencesOfString:@"<"withString:@""] 
                           stringByReplacingOccurrencesOfString:@">" withString:@""] 
                          stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"device_token"]) {
        [[NSUserDefaults standardUserDefaults] setValue:self.devToken forKey:@"device_token"];
    }
    
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"%@",error);
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

@end
