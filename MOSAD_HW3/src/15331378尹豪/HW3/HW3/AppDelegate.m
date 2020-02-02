//
//  AppDelegate.m
//  HW3
//
//  Created by student5 on 2019/9/16.
//  Copyright © 2019 inntechy. All rights reserved.
//

#import "AppDelegate.h"
#import "./Controllers/SelectLanguageViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    //将slvc添加为rootvc
    SelectLanguageViewController *slvc = [[SelectLanguageViewController alloc]init];
    //self.window.rootViewController = slvc;//不再使用slvc作为rootvc
    //创建UINavigationController
    //该对象的栈只包含slvc
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:slvc];
    //将UINavigationController对象设置为UIWidow的rootVC，以添加navC对象的视图到屏幕上
    self.window.rootViewController = navController;
    //防止navBar遮挡
    [[UINavigationBar appearance] setTranslucent:NO];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
