//
//  AppDelegate.m
//  SPOSample
//
//  Created by Elf Sundae on 13-5-7.
//  Copyright (c) 2013年 www.0x123.com. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [self.window makeKeyAndVisible];
        
        UINavigationController *root = [[UINavigationController alloc] initWithRootViewController:
                                        [[RootViewController alloc] init]];
        self.window.rootViewController = root;
        
        return YES;
}


@end
