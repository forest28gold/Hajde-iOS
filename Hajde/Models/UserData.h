//
//  UserData.h
//  Hajde
//
//  Created by AppsCreationTech on 3/13/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserData : NSObject

@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *deviceUUID;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *signup;
@property (nonatomic, assign) CGFloat latitude;
@property (nonatomic, assign) CGFloat longitude;
@property (strong, nonatomic) NSString *country;

@property (nonatomic, assign) int karmaScore;
@property (nonatomic, assign) int postCount;
@property (nonatomic, assign) int commentCount;
@property (nonatomic, assign) int voteCount;
@property (nonatomic, assign) int spentTime;
@property (nonatomic, assign) int dailyLoginCount;
@property (strong, nonatomic) NSString *lastLogin;
@property (strong, nonatomic) NSString *language;

@end
