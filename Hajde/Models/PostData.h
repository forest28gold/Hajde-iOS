//
//  PostData.h
//  Hajde
//
//  Created by AppsCreationTech on 3/29/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostData : NSObject

@property (strong, nonatomic) NSString *objectId;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *backColor;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *filePath;
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) NSString *period;
@property (nonatomic, assign) int imgHeight;
@property (nonatomic, assign) int commentCount;
@property (nonatomic, assign) int likeCount;
@property (nonatomic, assign) int reportCount;
@property (strong, nonatomic) NSString *commentType;
@property (strong, nonatomic) NSString *likeType;
@property (strong, nonatomic) NSString *reportType;
@property (strong, nonatomic) NSMutableArray *commentTypeArray;
@property (strong, nonatomic) NSMutableArray *likeTypeArray;
@property (strong, nonatomic) NSMutableArray *reportTypeArray;

@property (strong, nonatomic) UIImage *postPhoto;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@end
