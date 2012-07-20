//
//  QuAppDelegate.h
//  voldemort
//
//  Created by  on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZMQObjC.h"

#define MESSAGE_PREFIX "VDO"


@interface QuAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) IBOutlet UIWindow *window;
@property (strong, nonatomic) IBOutlet NSString *devToken;

@property (nonatomic, strong) ZMQContext *zmqContext;
@property (nonatomic, strong) ZMQSocket *reqSocket;

@end
