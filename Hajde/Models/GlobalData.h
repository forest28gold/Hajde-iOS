//
//  GlobalData.h
//  Hajde
//
//  Created by AppsCreationTech on 3/13/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "HDTabBarViewController.h"
#import "HDTabHomeViewController.h"
#import "DataModel.h"
#import "DBHandler.h"
#import "UserData.h"
#import "NSDate+NVTimeAgo.h"
#import "PostData.h"
#import "Shop.h"
#import "Offer.h"
#import "AutoFormatter.h"

@interface GlobalData : NSObject

@property (nonatomic, retain) AppDelegate                   *g_appDelegate;
@property (nonatomic, retain) DBHandler                     *g_dBHandler;
@property (nonatomic, retain) DataModel                     *g_dataModel;
@property (strong, nonatomic) HDTabBarViewController        *g_tabBar;
@property (strong, nonatomic) HDTabHomeViewController       *g_ctrlTabHome;
@property (nonatomic, retain) UserData                      *g_userInfo;
@property (nonatomic, retain) UserData                      *g_userDataModel;
@property (nonatomic, retain) AutoFormatter                 *g_autoFormat;
@property (strong, nonatomic) NSMutableArray                *g_arrayTermsUse;
@property (strong, nonatomic) NSMutableArray                *g_arrayPrivacyPolicy;
@property (strong, nonatomic) NSMutableArray                *g_arrayWhatsKarma;

@property (strong, nonatomic) NSString                      *g_strRecordFileName;
@property (strong, nonatomic) NSURL                         *g_strRecordFileUrl;
@property (nonatomic, assign) BOOL                          g_toggleRecordFileIsOn;

@property (nonatomic, assign) BOOL                          g_toggleCommentIsOn;
@property (nonatomic, retain) PostData                      *g_postData;
@property (strong, nonatomic) NSMutableArray                *g_arrayNewestPost;
@property (strong, nonatomic) NSMutableArray                *g_arrayMostCommentedPost;
@property (strong, nonatomic) NSMutableArray                *g_arrayMostVotesPost;

@property (nonatomic, assign) BOOL                          g_toggleMyPostIsOn;
@property (strong, nonatomic) NSMutableArray                *g_arrayMyNewestPost;
@property (strong, nonatomic) NSMutableArray                *g_arrayMyMostCommentedPost;
@property (strong, nonatomic) NSMutableArray                *g_arrayMyMostVotesPost;
@property (strong, nonatomic) NSMutableArray                *g_arrayMyCommentedPost;
@property (strong, nonatomic) NSMutableArray                *g_arrayMyVotesPost;

@property (strong, nonatomic) UIImage                       *g_imgPostBack;

@property (nonatomic, assign) int                           g_spentDays;
@property (nonatomic, assign) int                           g_spentHours;
@property (nonatomic, assign) int                           g_spentMins;

@property (strong, nonatomic) NSString                      *g_strSelectedTab;

@property (nonatomic, retain) Shop                          *g_shopData;
@property (nonatomic, retain) Offer                         *g_offerData;

@property (strong, nonatomic) NSString                      *g_strPhotoUrl;
@property (nonatomic, assign) BOOL                          g_togglePhotoIsOn;

@property (nonatomic, assign) CGFloat                       g_emojiX;
@property (nonatomic, assign) CGFloat                       g_emojiY;

@property (nonatomic, assign) BOOL                          g_toggleLanguageIsOn;
@property (nonatomic, assign) BOOL                          g_toggleTermsIsOn;

@property (strong, nonatomic) NSString                      *g_strCurrency;


+ (GlobalData *) sharedGlobalData;

- (BOOL) checkingVaildateEmailWithString:(NSString *)strEmail;
- (NSString *) trimString:(NSString *)string;
- (NSDate *)dateFromString:(NSString *)strDate DateFormat:(NSString *)strDateFormat TimeZone:(NSTimeZone *)timeZone;
- (void) saveToUserDefaultsWithValue:(id)value Key:(NSString *)strKey;
- (id) userDefaultWithKey:(NSString *)strKey;
- (void) removeValueFromUserDefaults:(NSString *)strKey;

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIColor *)colorWithHexString:(NSString *)colorString;

- (NSString*)getCurrentDate;
- (NSString*)getFormattedCount:(int)count;
- (NSString*)getFormattedDistance:(CLLocation*)fromLocation toLocation:(CLLocation*)toLocation;
- (int)getDistance:(CLLocation*)fromLocation toLocation:(CLLocation*)toLocation;
- (NSString*)getFormattedTimeStamp:(NSString*)time;
- (void)getSpentTimeStamp:(int)spentTime;
- (BOOL)getDailyLoginIsOn:(NSString*)currentLoginTime createdTime:(NSString*)createdTime;
- (void)onErrorAlert:(NSString*)errorString;
- (void)updateUserDataDB;

@end
