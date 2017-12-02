//
//  ActivityPostData.h
//  Hajde
//
//  Created by AppsCreationTech on 5/4/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityPostData : NSObject

@property (strong, nonatomic) NSString *objectId;
@property (strong, nonatomic) NSString *postId;
@property (strong, nonatomic) NSString *fromUser;
@property (strong, nonatomic) NSString *backColor;
@property (strong, nonatomic) NSString *toUser;
@property (strong, nonatomic) NSString *comment;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *time;
@property (nonatomic, assign) int likeCount;
@property (nonatomic, assign) int reportCount;
@property (strong, nonatomic) NSString *likeType;
@property (strong, nonatomic) NSMutableArray *likeTypeArray;
@property (strong, nonatomic) NSString *reportType;
@property (strong, nonatomic) NSMutableArray *reportTypeArray;

@end
