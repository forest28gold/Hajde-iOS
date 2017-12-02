//
//  DataModel.h
//  Hajde
//
//  Created by AppsCreationTech on 3/13/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#define TABLE_USER                      @"hajde_user"

#define FIELD_USER_ID                   @"userID"
#define FIELD_DEVICE_UUID               @"deviceUUID"
#define FIELD_PASSWORD                  @"password"
#define FIELD_SIGNUP             		@"signup"
#define FIELD_SPENT_TIME          		@"spentTime"
#define FIELD_POST_COUNT          		@"postCount"
#define FIELD_COMMENT_COUNT       		@"commentCount"
#define FIELD_VOTE_COUNT          		@"voteCount"
#define FIELD_KARMA_SCORE         		@"karmaScore"
#define FIELD_LOGIN_COUNT         		@"loginCount"
#define FIELD_LAST_LOGIN          		@"lastLogin"
#define FIELD_LANGUAGE                  @"language"
#define FIELD_COUNTRY                   @"country"

@interface DataModel : NSObject

@property (nonatomic) sqlite3 *dbHandler;


+ (BOOL)createTable:(sqlite3 *)dbHandler;
- (id)initWithDBHandler:(sqlite3*)dbHandler;
- (BOOL)updateUserDB;

@end
