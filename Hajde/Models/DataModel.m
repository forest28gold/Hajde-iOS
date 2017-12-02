//
//  DataModel.m
//  Hajde
//
//  Created by AppsCreationTech on 3/13/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel

@synthesize dbHandler;


+ (BOOL)createTable:(sqlite3 *)dbHandler {
	NSString* strQuery = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT);", TABLE_USER, FIELD_USER_ID, FIELD_DEVICE_UUID, FIELD_PASSWORD, FIELD_SIGNUP, FIELD_LAST_LOGIN, FIELD_SPENT_TIME, FIELD_POST_COUNT, FIELD_COMMENT_COUNT, FIELD_VOTE_COUNT, FIELD_KARMA_SCORE, FIELD_LOGIN_COUNT, FIELD_LANGUAGE, FIELD_COUNTRY];
    
	if (sqlite3_exec(dbHandler, [strQuery UTF8String], NULL, NULL, NULL) != SQLITE_OK)
		return NO;

	return YES;
}

-(id)initWithDBHandler:(sqlite3*)_dbHandler {
	self = [super init];
	
	if (self) {
		self.dbHandler = _dbHandler;
        
		NSString *strQuery_user = [NSString stringWithFormat:@"SELECT * FROM %@", TABLE_USER];
        sqlite3_stmt* stmt_user;
		
		if (sqlite3_prepare_v2(dbHandler, [strQuery_user UTF8String], -1, &stmt_user, NULL) == SQLITE_OK) {
			//int userId;
            [GlobalData sharedGlobalData].g_userDataModel = [[UserData alloc] init];
			while(sqlite3_step(stmt_user) == SQLITE_ROW) {
               UserData * record = [[UserData alloc] init];
                record.userID = @"";
                record.deviceUUID = @"";
                record.password = @"";
                record.signup = @"";
                record.lastLogin = @"";
                record.spentTime = 0;
                record.postCount = 0;
                record.commentCount = 0;
                record.voteCount = 0;
                record.karmaScore = 0;
                record.dailyLoginCount = 0;
                record.language = @"";
                record.country = @"";
                
				char *userID = (char*)sqlite3_column_text(stmt_user, 0);
                char *deviceUUID = (char*)sqlite3_column_text(stmt_user, 1);
                char *password = (char*)sqlite3_column_text(stmt_user, 2);
                char *signup = (char*)sqlite3_column_text(stmt_user, 3);
                char *lastLogin = (char*)sqlite3_column_text(stmt_user, 4);
                char *spentTime = (char*)sqlite3_column_text(stmt_user, 5);
                char *postCount = (char*)sqlite3_column_text(stmt_user, 6);
                char *commentCount = (char*)sqlite3_column_text(stmt_user, 7);
                char *voteCount = (char*)sqlite3_column_text(stmt_user, 8);
                char *karmaScore = (char*)sqlite3_column_text(stmt_user, 9);
                char *dailyLoginCount = (char*)sqlite3_column_text(stmt_user, 10);
                char *language = (char*)sqlite3_column_text(stmt_user, 11);
                char *country = (char*)sqlite3_column_text(stmt_user, 12);
                
				if (userID != nil)
					record.userID = [NSString stringWithUTF8String:userID];
                
                if (deviceUUID != nil)
                    record.deviceUUID = [NSString stringWithUTF8String:deviceUUID];
                
                if (password != nil)
                    record.password = [NSString stringWithUTF8String:password];
                
                if (signup != nil)
                    record.signup = [NSString stringWithUTF8String:signup];
                
                if (lastLogin != nil)
                    record.lastLogin = [NSString stringWithUTF8String:lastLogin];
                
                if (spentTime != nil)
                    record.spentTime = (int)[[NSString stringWithUTF8String:spentTime] integerValue];
                
                if (postCount != nil)
                    record.postCount = (int)[[NSString stringWithUTF8String:postCount] integerValue];
                
                if (commentCount != nil)
                    record.commentCount = (int)[[NSString stringWithUTF8String:commentCount] integerValue];
                
                if (voteCount != nil)
                    record.voteCount = (int)[[NSString stringWithUTF8String:voteCount] integerValue];
                
                if (karmaScore != nil)
                    record.karmaScore = (int)[[NSString stringWithUTF8String:karmaScore] integerValue];
                
                if (dailyLoginCount != nil)
                    record.dailyLoginCount = (int)[[NSString stringWithUTF8String:dailyLoginCount] integerValue];
                
                if (language != nil)
                    record.language = [NSString stringWithUTF8String:language];
                
                if (country != nil)
                    record.country = [NSString stringWithUTF8String:country];

                [GlobalData sharedGlobalData].g_userDataModel = record;
                
			}
            sqlite3_finalize(stmt_user);
		}
        
	}
	return self;
}

- (BOOL)updateUserDB {
    NSString *strQuery = [NSString stringWithFormat:@"DELETE FROM %@", TABLE_USER];
    
    if (sqlite3_exec(dbHandler, [strQuery UTF8String], NULL, NULL, NULL) != SQLITE_OK)
        return NO;

    UserData* record = [[UserData alloc] init];
    record = [GlobalData sharedGlobalData].g_userDataModel;
    strQuery = [NSString stringWithFormat:@"INSERT INTO %@ VALUES('%@', '%@', '%@', '%@', '%@', '%d', '%d', '%d', '%d', '%d', '%d', '%@', '%@')",
                TABLE_USER,
                record.userID,
                record.deviceUUID,
                record.password,
                record.signup,
                record.lastLogin,
                record.spentTime,
                record.postCount,
                record.commentCount,
                record.voteCount,
                record.karmaScore,
                record.dailyLoginCount,
                record.language,
                record.country];
    
    if (sqlite3_exec(dbHandler, [strQuery UTF8String], NULL, NULL, NULL) != SQLITE_OK)
        return NO;
    
    return YES;
}

@end
