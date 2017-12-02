//
//  AppDelegate.m
//  Hajde
//
//  Created by AppsCreationTech on 3/12/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import "AppDelegate.h"
#import "HDGetStartedViewController.h"
#import "HDTabBarViewController.h"
//#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface AppDelegate () <IBEPushReceiver>
{
    NSTimer *m_timer;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [GlobalData sharedGlobalData].g_autoFormat = [AutoFormatter getInstance];
    
    [backendless initApp:BACKEND_APP_ID secret:BACKEND_SECRET_KEY version:BACKEND_VERSION_NUM];
    backendless.messagingService.pushReceiver = self;
    
    [GlobalData sharedGlobalData].g_dBHandler = [DBHandler connectDB];
    sqlite3* dbHandler = [[GlobalData sharedGlobalData].g_dBHandler getDbHandler];
    [GlobalData sharedGlobalData].g_dataModel = [[DataModel alloc] initWithDBHandler:dbHandler];
    
    [GlobalData sharedGlobalData].g_userInfo = [[UserData alloc] init];
    [GlobalData sharedGlobalData].g_userInfo = [GlobalData sharedGlobalData].g_userDataModel;    
    
    [GlobalData sharedGlobalData].g_arrayPrivacyPolicy = [[NSMutableArray alloc] init];
    [GlobalData sharedGlobalData].g_arrayTermsUse = [[NSMutableArray alloc] init];
    [GlobalData sharedGlobalData].g_arrayWhatsKarma = [[NSMutableArray alloc] init];
    
    m_timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateSpentTime) userInfo:nil repeats:YES];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *controller = (UINavigationController*)[storyboard instantiateViewControllerWithIdentifier:@"RootNavigationController"];
    
    if ([[GlobalData sharedGlobalData].g_userInfo.signup isEqualToString:USER_LOGIN]) {
        
        NSString *currentLoginTime = [[GlobalData sharedGlobalData] getCurrentDate];
        
        if ([[GlobalData sharedGlobalData] getDailyLoginIsOn:currentLoginTime createdTime:[GlobalData sharedGlobalData].g_userInfo.lastLogin]) {
            
            [GlobalData sharedGlobalData].g_userInfo.karmaScore += KARMA_SCORE_LOGIN;
            [HDUtility karmaInBackground:KARMA_LOGIN];
        }
        
        [[GlobalData sharedGlobalData] updateUserDataDB];

//        dispatch_async(dispatch_get_main_queue(), ^{
//            [backendless.userService login:[GlobalData sharedGlobalData].g_userInfo.userID password:[GlobalData sharedGlobalData].g_userInfo.password response:^(BackendlessUser *user) {
//                NSLog(@"========= Login is succeed! ================");
//            } error:^(Fault *fault) {
//                NSLog(@"========= Login is failed! ================");
//            }];
//        });
        
        if ([[GlobalData sharedGlobalData].g_userInfo.language isEqualToString:LANG_ALB]) {
            [NSBundle setLanguage:@"sq"];
        } else {
            [NSBundle setLanguage:@"en"];
        }
        
        HDTabBarViewController *tabController = [storyboard instantiateViewControllerWithIdentifier:VIEW_TAB];
        [controller setViewControllers:[NSArray arrayWithObject:tabController] animated:YES];
        
    } else {
        
        NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
        
        if ([language containsString:@"en"]) {
            [GlobalData sharedGlobalData].g_userInfo.language = LANG_ENG;
            [NSBundle setLanguage:@"en"];
        } else {
            [GlobalData sharedGlobalData].g_userInfo.language = LANG_ALB;
            [NSBundle setLanguage:@"sq"];
        }
        
        [[GlobalData sharedGlobalData] updateUserDataDB];

        HDGetStartedViewController *getStartController = [storyboard instantiateViewControllerWithIdentifier:VIEW_GET_STARTED];
        [controller setViewControllers:[NSArray arrayWithObject:getStartController] animated:YES];        
    }
    
    self.window.rootViewController=controller;
    
//    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [m_timer invalidate];
    
    NSLog(@"Spent Time ======= %d", [GlobalData sharedGlobalData].g_userInfo.spentTime);
    
    [[GlobalData sharedGlobalData] updateUserDataDB];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    m_timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateSpentTime) userInfo:nil repeats:YES];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [m_timer invalidate];
    [backendless.messaging applicationWillTerminate];
}

//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
//    
//   return [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
//}

- (void)updateSpentTime {
    
    [GlobalData sharedGlobalData].g_userInfo.spentTime++;
    
    [[GlobalData sharedGlobalData] getSpentTimeStamp:[GlobalData sharedGlobalData].g_userInfo.spentTime];
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
    [backendless.messaging didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    [backendless.messaging didFailToRegisterForRemoteNotificationsWithError:err];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [backendless.messaging didReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))handler {
    
    [backendless.messaging didReceiveRemoteNotification:userInfo];
    handler(UIBackgroundFetchResultNewData);
}

#pragma mark -
#pragma mark IBEPushReceiver Methods

-(void)didReceiveRemoteNotification:(NSString *)notification headers:(NSDictionary *)headers {
    
    if ([notification rangeOfString:@"post"].location != NSNotFound && [notification rangeOfString:@"downvotes"].location != NSNotFound) {
        
        [GlobalData sharedGlobalData].g_userInfo.karmaScore += KARMA_SCORE_DELETE_POST;
        [GlobalData sharedGlobalData].g_userInfo.postCount --;
        [[GlobalData sharedGlobalData] updateUserDataDB];
        [HDUtility karmaDecreaseInBackground:KARMA_DECREASE_DELETE_POST];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"karma", "")
                                                        message:NSLocalizedString(@"karma_post_5_downvotes", "")
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"ok", "")
                                              otherButtonTitles:nil];
        [alert show];
        
    } else if ([notification rangeOfString:@"comment"].location != NSNotFound && [notification rangeOfString:@"downvotes"].location != NSNotFound) {
        
        [GlobalData sharedGlobalData].g_userInfo.karmaScore += KARMA_SCORE_DELETE_POST;
        [GlobalData sharedGlobalData].g_userInfo.commentCount --;
        [[GlobalData sharedGlobalData] updateUserDataDB];
        [HDUtility karmaDecreaseInBackground:KARMA_DECREASE_DELETE_COMMENT];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"karma", "")
                                                        message:NSLocalizedString(@"karma_comment_5_downvotes", "")
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"ok", "")
                                              otherButtonTitles:nil];
        [alert show];
    } else if ([notification rangeOfString:@"post"].location != NSNotFound && [notification rangeOfString:@"downvote"].location != NSNotFound) {
        
        [GlobalData sharedGlobalData].g_userInfo.karmaScore += KARMA_SCORE_DECREASE_POST;
        [[GlobalData sharedGlobalData] updateUserDataDB];
        [HDUtility karmaDecreaseInBackground:KARMA_DECREASE_POST];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"karma", "")
                                                        message:NSLocalizedString(@"karma_someone_downvote_post", "")
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"ok", "")
                                              otherButtonTitles:nil];
        [alert show];
        
    } else if ([notification rangeOfString:@"comment"].location != NSNotFound && [notification rangeOfString:@"downvote"].location != NSNotFound) {
        
        [GlobalData sharedGlobalData].g_userInfo.karmaScore += KARMA_SCORE_DECREASE_POST;
        [[GlobalData sharedGlobalData] updateUserDataDB];
        [HDUtility karmaDecreaseInBackground:KARMA_DECREASE_COMMENT];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"karma", "")
                                                        message:NSLocalizedString(@"karma_someone_downvote_comment", "")
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"ok", "")
                                              otherButtonTitles:nil];
        [alert show];
    } else if ([notification rangeOfString:@"post"].location != NSNotFound && [notification rangeOfString:@"report"].location != NSNotFound) {
        
        [GlobalData sharedGlobalData].g_userInfo.karmaScore += KARMA_SCORE_DELETE_POST;
        [GlobalData sharedGlobalData].g_userInfo.postCount --;
        [[GlobalData sharedGlobalData] updateUserDataDB];
        [HDUtility karmaDecreaseInBackground:KARMA_REPORT_DELETE_POST];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"karma", "")
                                                        message:NSLocalizedString(@"karma_delete_post", "")
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"ok", "")
                                              otherButtonTitles:nil];
        [alert show];
        
    } else if ([notification rangeOfString:@"comment"].location != NSNotFound && [notification rangeOfString:@"report"].location != NSNotFound) {
        
        [GlobalData sharedGlobalData].g_userInfo.karmaScore += KARMA_SCORE_DELETE_POST;
        [GlobalData sharedGlobalData].g_userInfo.commentCount --;
        [[GlobalData sharedGlobalData] updateUserDataDB];
        [HDUtility karmaDecreaseInBackground:KARMA_REPORT_DELETE_COMMENT];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"karma", "")
                                                        message:NSLocalizedString(@"karma_delete_comment", "")
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"ok", "")
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    
    
    if ([notification rangeOfString:@"postimi"].location != NSNotFound && [notification rangeOfString:@"votime"].location != NSNotFound) {
        
        [GlobalData sharedGlobalData].g_userInfo.karmaScore += KARMA_SCORE_DELETE_POST;
        [GlobalData sharedGlobalData].g_userInfo.postCount --;
        [[GlobalData sharedGlobalData] updateUserDataDB];
        [HDUtility karmaDecreaseInBackground:KARMA_DECREASE_DELETE_POST];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"karma", "")
                                                        message:NSLocalizedString(@"karma_post_5_downvotes", "")
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"ok", "")
                                              otherButtonTitles:nil];
        [alert show];
        
    } else if ([notification rangeOfString:@"komenti"].location != NSNotFound && [notification rangeOfString:@"votime"].location != NSNotFound) {
        
        [GlobalData sharedGlobalData].g_userInfo.karmaScore += KARMA_SCORE_DELETE_POST;
        [GlobalData sharedGlobalData].g_userInfo.commentCount --;
        [[GlobalData sharedGlobalData] updateUserDataDB];
        [HDUtility karmaDecreaseInBackground:KARMA_DECREASE_DELETE_COMMENT];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"karma", "")
                                                        message:NSLocalizedString(@"karma_comment_5_downvotes", "")
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"ok", "")
                                              otherButtonTitles:nil];
        [alert show];
    } else if ([notification rangeOfString:@"postimi"].location != NSNotFound && [notification rangeOfString:@"votimit"].location != NSNotFound) {
        
        [GlobalData sharedGlobalData].g_userInfo.karmaScore += KARMA_SCORE_DECREASE_POST;
        [[GlobalData sharedGlobalData] updateUserDataDB];
        [HDUtility karmaDecreaseInBackground:KARMA_DECREASE_POST];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"karma", "")
                                                        message:NSLocalizedString(@"karma_someone_downvote_post", "")
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"ok", "")
                                              otherButtonTitles:nil];
        [alert show];
        
    } else if ([notification rangeOfString:@"komenti"].location != NSNotFound && [notification rangeOfString:@"votimit"].location != NSNotFound) {
        
        [GlobalData sharedGlobalData].g_userInfo.karmaScore += KARMA_SCORE_DECREASE_POST;
        [[GlobalData sharedGlobalData] updateUserDataDB];
        [HDUtility karmaDecreaseInBackground:KARMA_DECREASE_COMMENT];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"karma", "")
                                                        message:NSLocalizedString(@"karma_someone_downvote_comment", "")
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"ok", "")
                                              otherButtonTitles:nil];
        [alert show];
    } else if ([notification rangeOfString:@"postimi"].location != NSNotFound && [notification rangeOfString:@"raportimit"].location != NSNotFound) {
        
        [GlobalData sharedGlobalData].g_userInfo.karmaScore += KARMA_SCORE_DELETE_POST;
        [GlobalData sharedGlobalData].g_userInfo.postCount --;
        [[GlobalData sharedGlobalData] updateUserDataDB];
        [HDUtility karmaDecreaseInBackground:KARMA_REPORT_DELETE_POST];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"karma", "")
                                                        message:NSLocalizedString(@"karma_delete_post", "")
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"ok", "")
                                              otherButtonTitles:nil];
        [alert show];
        
    } else if ([notification rangeOfString:@"komenti"].location != NSNotFound && [notification rangeOfString:@"raportimit"].location != NSNotFound) {
        
        [GlobalData sharedGlobalData].g_userInfo.karmaScore += KARMA_SCORE_DELETE_POST;
        [GlobalData sharedGlobalData].g_userInfo.commentCount --;
        [[GlobalData sharedGlobalData] updateUserDataDB];
        [HDUtility karmaDecreaseInBackground:KARMA_REPORT_DELETE_COMMENT];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"karma", "")
                                                        message:NSLocalizedString(@"karma_delete_comment", "")
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"ok", "")
                                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)didRegisterForRemoteNotificationsWithDeviceId:(NSString *)deviceId fault:(Fault *)fault {
    
    if (fault) {
        NSLog(@"didRegisterForRemoteNotificationsWithDeviceId: (FAULT) %@", fault);
        return;
    }
    NSLog(@"didRegisterForRemoteNotificationsWithDeviceId: %@", deviceId);
}

-(void)didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError: %@", err);
}


@end
